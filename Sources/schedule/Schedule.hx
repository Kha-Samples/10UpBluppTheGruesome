package schedule;

class Schedule {
	private var tasks: Array<Task>;
	private var currentTask: Task;
	
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
}
