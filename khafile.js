let project = new Project('10Up');

project.addLibrary('Kha2D');

project.addAssets('Assets/**');

project.addSources('Sources');

resolve(project);
