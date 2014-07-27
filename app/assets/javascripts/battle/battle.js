app.controller("BattleController", ["$scope", "$http", function($scope, $http) {
	$scope.player = new Battler();
	$scope.enemy = new Battler();
	$scope.log = ["what", "is", "this"];
	
	$scope.explore = function() {
		$http.get("/explore/explore").success($scope.exploreSuccess).error($scope.exploreFail);
	};
	
	$scope.exploreSuccess = function(data, status, headers, config) {
		console.log("Engaged data", data, "with status", status, "and headers", headers, "and config", config);
		$scope.enemy.update(data);
	};
	
	$scope.exploreFail = function(data, status, headers, config) {
		console.log("Failed to explore", data, status, headers, config);
	};
	
	$scope.attack = function() {
		$http.get("/explore/attack", {}).success($scope.attackSuccess).error($scope.attackFail);
	};
	
	$scope.attackSuccess = function(data, status, headers, config) {
		console.log("Attacked data", data, "with status", status, "and headers", headers, "and config", config);
		$scope.player.hp = data.battle.player.hp;
		$scope.enemy.hp = data.battle.enemy.hp;
		$.each(data.messages, function(index, message) {
			$scope.log.push(message);
		});
	};
	
	$scope.attackFail = function(data, status, headers, config) {
		console.log("Failed to attack", data, status, headers, config);
	};
	
	$scope.loadPlayer = function(data, status, headers, config) {
		$scope.player.update(data);
	};
	
	$scope.player.update($("#initial-battler").data("player"));
}]);