/* Inventory Specific Code */ if (controller === "inventory") { /* */

//
// APPLICATION
//
	
app.run(["$rootScope", function($rootScope) {
	
}]);

//
// CONTROLLERS
//

app.controller("InventoryController", ["$scope", "$http", "Inventory", function($scope, $http, Inventory) {
	$scope.bags = Inventory.bags();
	$scope.equipped = Inventory.equipped({}, function() { updatePlaceholders(); });
	$scope.placeholders = [];
	$scope.stats = null;
	
	$scope.equip = function(item) {
		if (item.equipped || !isEquippable(item)) {
			return;
		}
		var equipped = getEquippedByType(item.type, item.subtype);
		unequipItem(equipped);
		equipItem(item);
		updatePlaceholders();
		$http.post("/inventory/equip", { id: item.id }).error(function(data, status) {
			equipItem(equipped);
			unequipItem(item);
			console.error("Could not equip item", item, "got status", status);
			updatePlaceholders();
		}).success(updateStats);
	};
	
	$scope.unequip = function(item) {
		if (!item.equipped || !isEquippable(item)) {
			return;
		}
		unequipItem(item);
		updatePlaceholders();
		$http.post("/inventory/unequip", { id: item.id }).error(function(data, status) {
			equipItem(item);
			console.error("Could not unequip item", item, "got status", status);
			updatePlaceholders();
		}).success(updateStats);
	};
	
	var equipItem = function(item) {
		if (item == null) {
			return;
		}
		$scope.bags.splice($scope.bags.indexOf(item), 1);
		$scope.equipped.push(item);
		item.equipped = true;
		updatePlaceholders();
	};
	
	var unequipItem = function(item) {
		if (item == null) {
			return;
		}
		$scope.equipped.splice($scope.equipped.indexOf(item), 1);
		$scope.bags.push(item);
		item.equipped = false;
	};
	
	var getEquippedByType = function(type, subtype) {
		for (var i = 0; i < $scope.equipped.length; i++) {
			var item = $scope.equipped[i];
			if (item.type == type && (item.type == "Weapon" || item.subtype == subtype)) {
				return item;
			}
		}
		return null;
	};
	
	var isEquippable = function(item) {
		return item.type == "Weapon" || item.type == "Armor";
	};
	
	var updateStats = function(data) {
		$scope.stats = data.stats;
	};
	
	var TYPES = ["Weapon", "Helmet", "Chestpiece", "Legplates", "Belt", "Boots", "Shield", "Bracers", "Amulet", "Ring", "Tool"];
	var updatePlaceholders = function() {
		$scope.placeholders = [];
		var equipTypes = {};
		$.each($scope.equipped, function(index, item) {
			var type = item.type == "Weapon" ? item.type : item.subtype;
			equipTypes[type] = true;
		});
		$.each(TYPES, function(index, type) {
			if (!equipTypes[type]) {
				var image = "items/placeholder_" + type.toLowerCase() + ".png";
				$scope.placeholders.push({
					image_path: image,
					type: type,
					subtype: type,
					rarity: "Common",
					placeholder: true,
				});
			}
		});
	};
	
	// Initialize
	$http.get("/inventory/stats").success(updateStats);
}]);

//
// SERVICES
//

app.factory("Inventory", ["$rootScope", "$resource", function($rootScope, $resource) {
	return $resource("/inventory/:action", {}, {
		bags: { method: "GET", params: { action: "bags" }, isArray: true },
		equipped: { method: "GET", params: { action: "equipped" }, isArray: true }
	});
}]);

app.factory("Tooltip", ["$rootScope", function($rootScope) {
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

app.directive("item", ["$timeout", "Tooltip", "ContextMenu", function($timeout, Tooltip, ContextMenu) {
	return {
		restrict: "E",
		controller: ["$scope", "$element", "$attrs", function($scope, $element, $attrs) {
			
		}],
		template: "<div class=\"item\"><img></img></div>",
		replace: true,
		link: function(scope, element, attrs) {
			element.find("img")
			.attr("src", "images/" + scope.item.image_path)
			.end()
			.addClass(scope.item.type)
			.addClass(scope.item.subtype)
			.addClass(scope.item.rarity)
			.click(function() {
				scope.$apply(function() {
					if (scope.item.equipped) {
						scope.unequip(scope.item);
					} else {
						scope.equip(scope.item);
					}
					Tooltip.hide();
				});
			}).hover(function() {
				if (!scope.item.placeholder) {
					scope.$apply(function() {
						Tooltip.show(scope.item, element);
					});
				}
			}, function() {
				scope.$apply(function() {
					Tooltip.hide();
				});
			}).on("contextmenu", function(event) {
				ContextMenu.show(event, "item", scope.item);
			});
			if (scope.item.placeholder) {
				element.addClass("placeholder");
			}
		}
	};
}]);

app.directive("tooltip", [function() {
	var WINDOW_PADDING = 20;
	var ITEM_PADDING = 4;
	
	return {
		restrict: "A",
		controller: ["$scope", function($scope) {
			$scope.item = null;
		}],
		link: function(scope, element, attrs) {
			scope.$on("showTooltip", function(event, item, target) {
				var position = $(target).offset();
				var left = position.left + $(target).outerWidth() + ITEM_PADDING;
				var top = position.top;
				var width = $(element).width();
				var height = $(element).height();
				var windowWidth = $(window).width();
				var windowHeight = $(window).height();
				
				if (left + width > windowWidth - WINDOW_PADDING) {
					left = left - ITEM_PADDING * 2 - 38 - width;
				}
				
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

app.directive("contextMenu", [function() {
	return {
		restrict: "A",
		controller: ["$scope", function($scope) {
			
		}],
	};
}]);

//
// FILTERS
//

app.filter("displayEffect", function() {
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