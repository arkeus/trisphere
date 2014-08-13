app.controller("BattleController", ["$rootScope", "$scope", "$http", function($rootScope, $scope, $http) {
	$scope.inBattle = false;
	$scope.complete = false;
	$scope.player = new Battler();
	$scope.enemy = new Battler();
	$scope.debug = null;
	$scope.log = [];
	
	$scope.explore = function() {
		$http.get("/explore/explore").success($scope.exploreSuccess).error($scope.exploreFail);
	};
	
	$scope.exploreSuccess = function(data, status, headers, config) {
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
	
	$scope.useSkill = function(skill) {
		$http.get("/explore/skill?id=" + skill.id, {}).success($scope.attackSuccess).error($scope.attackFail);
	};
	
	$scope.attackSuccess = function(data, status, headers, config) {
		processUpdate(data);
		if (data.complete) {
			$scope.complete = true;
			$rootScope.$broadcast("update-character", data.update);
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
		$scope.debug = data.battle.player;
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