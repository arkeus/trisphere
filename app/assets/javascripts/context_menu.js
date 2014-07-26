app.factory("ContextMenu", ["$rootScope", "ContextMenuBuilder", function($rootScope, ContextMenuBuilder) {
	var module = {};
	
	module.show = function(event, type, source) {
		event.preventDefault();
		var options = ContenxtMenuBuilder.build(type, source);
	};
	
	return module;
}]);

app.factory("ContextMenuBuilder", [function() {
	var module = {};
	
	var builders = {
		item: function(item) {
			var options = [];
			options.push("Equip");
			return options;
		}
	};
	
	module.build = function(type, source) {
		return builders[type](source);
	};
	
	return module;
}]);
