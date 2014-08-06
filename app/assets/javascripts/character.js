app.controller("CharacterController", ["$scope", function($scope) {
	$scope.user = null;
	$scope.character = null;
	
	$scope.initialize = function(user, character) {
		$scope.user = user;
		$scope.character = character;
	};
	
	$scope.$on("update-character", function(event, update) {
		var character = update.character;
		var user = update.user;
		for (var property in character) {
			$scope.character[property] = character[property];
		}
		for (var property in user) {
			$scope.user[property] = user[property];
		}
	});
}]);
