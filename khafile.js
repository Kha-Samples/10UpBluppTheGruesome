let project = new Project('10UpBluppTheGruesome');
project.addSources('Sources');

project.addAssets('Assets/data/*');
project.addAssets('Assets/fonts/*');
project.addAssets('Assets/Graphics/**');

project.addAssets('Assets/Graphics2x/**', {
	scale: 2.0,
	background: {
    	red: 255,
    	green: 174,
    	blue: 201
	}
});

project.addAssets('Assets/GraphicsStencil/**', {
	background: {
    	red: 255,
    	green: 174,
    	blue: 201
	}
});

project.addLibrary('Kha2D');
resolve(project);
