var exec = require('cordova/exec');
    function SaveImages() {}
        SaveImages.prototype.downloadImage = function(win,fail,options) {
	       exec(win,fail, "SaveImages", "downloadImage",options);
	    }       
	var saveimages = new SaveImages();
    module.exports = saveimages