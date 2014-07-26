app.controller("BattleController", ["$scope", "$http", function($scope, $http) {
	$scope.player = new Battler();
	$scope.enemy = new Battler();
	
	$scope.explore = function() {
		$http.get("/explore/explore").success($scope.engage);
	};
	
	$scope.engage = function(data, status, headers, config) {
		console.log("Engaged data", data, "with status", status, "and headers", headers, "and config", config);
		$scope.enemy.update(data);
	};
	
	$scope.loadPlayer = function(data, status, headers, config) {
		$scope.player.update(data);
	};
	
	$http.get("/explore/player").success($scope.loadPlayer);
}]);