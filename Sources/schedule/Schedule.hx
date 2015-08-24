package schedule;

class Schedule {
	public var tasks: Array<Task>;
	public var currentTask: Task;
	
	public function new() {
		tasks = new Array<Task>();
		currentTask = null;
	}
	
	public function add(task: Task): Void {
		tasks.push(task);
	}
	
	public var length(get, null): Int;
	
	private function get_length(): Int {
		return tasks.length;
	}
	
	public function update(): Void {
		if (currentTask == null) {
			currentTask = tasks.shift();
		}
		if (currentTask != null) {
			if (currentTask.isDone()) {
				currentTask = tasks.shift();
			}
			if (currentTask != null) {
				currentTask.update();
			}
		}
	}
	
	public function end(): Void {
		if (tasks.length < 10) {
			for (i in 0...5) {
				var task = tasks.shift();
				if (task != null) {
					task.doImmediately();
				}
			}
		}
		else {
			for (i in 0...15) {
				var task = tasks.shift();
				if (task != null) {
					task.doImmediately();
				}
			}
		}
		tasks = [];
		currentTask = null;
	}
	
	public function nextTwoTaskDescription(): String
	{
		var task1 = currentTask;
		var index = 0;
		while (Std.is(task1, MoveTask)) task1 = tasks[index++];
		var task2 = tasks[index++];
		while (Std.is(task2, MoveTask)) task2 = tasks[index++];
		return Localization.getText(Keys_text.TASK, [task1.getDescription(), task2.getDescription()]);
	}
}
