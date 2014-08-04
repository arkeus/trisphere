app.controller("CharacterController", ["$scope", function($scope) {
	$scope.character = null;
	$scope.gold = null;
	$scope.shards = null;
	
	$scope.initialize = function(gold, shards, character) {
		$scope.character = character;
		$scope.gold = gold;
		$scope.shards = shards;
	};
	
	$scope.$on("update-character", function(event, character) {
		console.log("update", character);
		for (var property in character) {
			console.log("setting", property, "to", character[property]);
			var value = character[property];
			if (property == "gold") {
				$scope.gold = value;
			} else if (property == "shards") {
				$scope.shards = value;
			} else {
				$scope.character[property] = value;
			}
		}
	});
}]);
