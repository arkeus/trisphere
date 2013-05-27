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
				.addClass(scope.item.subtype);
			
			$(element).click(function() {
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
				scope.item = item;
				$(element).css({
					left: position.left + $(target).outerWidth() + 4,
					top: position.top
				}).show();
			});
			
			scope.$on("hideTooltip", function(event) {
				$(element).hide();
			});
		}
	};
}]);
	
/* End Inventory Specific Code */ } /* */