app.controller("BattleController", ["$scope", "$http", function($scope, $http) {
	$scope.inBattle = false;
	$scope.complete = false;
	$scope.player = new Battler();
	$scope.enemy = new Battler();
	$scope.log = ["what", "is", "this"];
	
	$scope.explore = function() {
		$http.get("/explore/explore").success($scope.exploreSuccess).error($scope.exploreFail);
	};
	
	$scope.exploreSuccess = function(data, status, headers, config) {
		console.log("Engaged data", data, "with status", status, "and headers", headers, "and config", config);
		processUpdate(data);
		$scope.inBattle = true;
		$scope.complete = false;
	};
	
	$scope.exploreFail = function(data, status, headers, config) {
		console.log("Failed to explore", status, headers, config);
	};
	
	$scope.attack = function() {
		$http.get("/explore/attack", {}).success($scope.attackSuccess).error($scope.attackFail);
	};
	
	$scope.attackSuccess = function(data, status, headers, config) {
		console.log("Attacked data", data, "with status", status, "and headers", headers, "and config", config);
		processUpdate(data);
		if (data.complete) {
			$scope.complete = true;
		}
	};
	
	$scope.attackFail = function(data, status, headers, config) {
		console.log("Failed to attack", status, headers, config);
	};
	
	$scope.loadPlayer = function(data, status, headers, config) {
		$scope.player.update(data);
	};
	
	var processUpdate = function(data) {
		$scope.enemy.update(data.battle.enemy);
		$scope.player.update(data.battle.player);
		logMessages(data.messages);
	};
	
	var logMessages = function(messages) {
		$.each(messages, function(index, message) {
			$scope.log.push(message);
		});
		$scope.$broadcast("log-message");
	};
	
	$scope.player.update($("#initial-battler").data("player"));
}]);