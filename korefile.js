var solution = new Solution('10up - Blupp the Gruesome');
var project = new Project('10up - Blupp the Gruesome');
project.setDebugDir('build/windows');
project.addSubProject(Solution.createProject('build/windows-build'));
project.addSubProject(Solution.createProject('D:/Documents/Eigene Programme/10upMonster/Kha'));
project.addSubProject(Solution.createProject('D:/Documents/Eigene Programme/10upMonster/Kha/Kore'));
solution.addProject(project);
if (fs.existsSync(path.join('Libraries/Kha2D', 'korefile.js'))) {
	project.addSubProject(Solution.createProject('Libraries/Kha2D'));
}
return solution;
