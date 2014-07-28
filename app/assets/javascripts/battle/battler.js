var Battler = function(source) {
	this.name = null;
	this.level = 0;
	this.hp = 0;
	this.hpm = 0;
	this.mp = 0;
	this.mpm = 0;
	this.status = [];
	
	this.update = function(source) {
		this.name = source.name;
		this.level = source.level;
		this.hp = source.hp;
		this.hpm = source.hpm;
		this.mp = source.mp;
		this.mpm = source.mpm;
	};
};
