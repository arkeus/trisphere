/* Inventory Specific Code */ if (controller === "inventory") { /* */

//
// APPLICATION
//
	
TSA.run(["$rootScope", function($rootScope) {
	
}]);

//
// CONTROLLERS
//

TSA.controller("InventoryController", ["$scope", "Inventory", function($scope, Inventory) {
	$scope.bags = Inventory.bags();
	$scope.equipped = Inventory.equipped();
	
	$scope.equip = function(item) {
		var equipped = getEquippedByType(item.type, item.subtype);
		console.log(equipped);
		if (equipped != null) {
			$scope.equipped.splice($scope.equipped.indexOf(equipped), 1);
			$scope.bags.push(equipped);
		}
		$scope.bags.splice($scope.bags.indexOf(item), 1);
		$scope.equipped.push(item);
	};
	
	var getEquippedByType = function(type, subtype) {
		for (var i = 0; i < $scope.equipped.length; i++) {
			var item = $scope.equipped[i];
			console.warn(item, item.type, type);
			if (item.type == type && (item.type == "Weapon" || item.subtype == subtype)) {
				return item;
			}
		}
		return null;
	};
}]);

//
// SERVICES
//

TSA.factory("Inventory", ["$rootScope", "$resource", function($rootScope, $resource) {
	return $resource("/inventory/:action", {}, {
		bags: { method: "GET", params: { action: "bags" }, isArray: true },
		equipped: { method: "GET", params: { action: "equipped" }, isArray: true }
	});
}]);

TSA.factory("Tooltip", ["$rootScope", function($rootScope) {
	var module = {};
	
	module.show = function(item, element) {
		$rootScope.$broadcast("showTooltip", item, element);
	};
	
	module.hide = function() {
		$rootScope.$broadcast("hideTooltip");
	};
	
	return module;
}]);

//
// DIRECTIVES
//

TSA.directive("item", ["$timeout", "Tooltip", function($timeout, Tooltip) {
	return {
		restrict: "E",
		controller: ["$scope", "$element", "$attrs", function($scope, $element, $attrs) {
			
		}],
		template: "<div class=\"item\"><img></img></div>",
		replace: true,
		link: function(scope, element, attrs) {
			$(element).find("img")
			.attr("src", "images/" + scope.item.image_path)
			.end()
			.addClass(scope.item.type)
			.addClass(scope.item.subtype)
			.addClass(scope.item.rarity)
			.click(function() {
				scope.$apply(function() {
					scope.equip(scope.item);
				});
			}).hover(function() {
				scope.$apply(function() {
					Tooltip.show(scope.item, element);
				});
			}, function() {
				scope.$apply(function() {
					Tooltip.hide();
				});
			});
		}
	};
}]);

TSA.directive("tooltip", [function() {
	return {
		restrict: "A",
		controller: ["$scope", function($scope) {
			$scope.item = null;
		}],
		link: function(scope, element, attrs) {
			scope.$on("showTooltip", function(event, item, target) {
				var position = $(target).offset();
				var left = position.left + $(target).outerWidth() + 4;
				var top = position.top;
				
				scope.item = item;
				$(element).css({
					left: left,
					top: top
				}).show();
			});
			
			scope.$on("hideTooltip", function(event) {
				$(element).hide();
			});
		}
	};
}]);

//
// FILTERS
//

TSA.filter("displayEffect", function() {
	return function(item) {
		if (!item) {
			return;
		}
		if (item.type == "Weapon") {
			return "<div class='weapon effect'><div class='damage icon'></div> " + item.effect[0] + "</div>" +
			"<div class='weapon effect align-center'><div class='mdamage icon'></div> " + item.effect[1] + "</div>" +
			"<div class='weapon effect align-center'><div class='accuracy icon'></div> " + item.effect[2] + "</div>" +
			"<div class='weapon effect align-right'><div class='price icon'></div> " + item.price + "</div>";
		} else if (item.type == "Armor") {
			return "<div class='armor effect'><div class='armor icon'></div> " + item.effect + "</div>" +
			"<div class='armor effect align-right'><div class='price icon'></div> " + item.price + "</div>";
		} else {
			return "<div class='other effect align-right'><div class='price icon'></div> " + item.price + "</div>";
		}
	};
});
	
/* End Inventory Specific Code */ } /* */