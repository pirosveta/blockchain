pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

struct task {
    string name;
    uint32 addTime;
    bool complete;
}

contract TaskList {
    
    mapping (int8 => task) taskList;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        
        tvm.accept();
    }

    modifier checkOwnerAndAccept() {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();

        _;
    }

    function addTask(string name) public checkOwnerAndAccept {
        int8 order = 1;
        optional(int8, task) lastTaskLine = taskList.max();

        if (lastTaskLine.hasValue()) {
            (int8 lastOrder, task lastTask) = lastTaskLine.get();
            order = lastOrder + 1;
        }
        
        taskList.add(order, task(name, now, false));
    }

    function getOpenTask() public checkOwnerAndAccept returns(int8 amount){
        amount = 0;
        optional(int8, task) currentTaskLine = taskList.next(0);

        while (currentTaskLine.hasValue()) {
            (int8 currentOrder, task currentTask) = currentTaskLine.get();
            
            if (!currentTask.complete) {
                amount++;
            }

            currentTaskLine = taskList.next(currentOrder);
        }
    }

    function getTaskList() public checkOwnerAndAccept returns(task[] tasks) {
        optional(int8, task) currentTaskLine = taskList.next(-1);

        while (currentTaskLine.hasValue()) {
            (int8 currentOrder, task currentTask) = currentTaskLine.get();
            
            tasks.push(currentTask);
            currentTaskLine = taskList.next(currentOrder);
        }
    }

    function getTask(int8 key) public checkOwnerAndAccept returns(string description) {
        if (taskList.exists(key)) {
            task currentTask = taskList.at(key);

            description = "Task - '" + currentTask.name + "' -";
            if (currentTask.complete) {
                description.append(" is complete;");
            }
            else description.append(" is not complete;");
        } 
        else revert(130, "The key does not exists");
    }

    function removeTask(int8 key) public checkOwnerAndAccept {
        if (taskList.exists(key)) {
            int8 currentOrder = key;
            optional(int8, task) nextTaskLine = taskList.next(key);

            while (nextTaskLine.hasValue()) {
                (int8 nextOrder, task nextTask) = nextTaskLine.get();

                taskList.replace(currentOrder, nextTask);
                currentOrder = nextOrder;

                nextTaskLine = taskList.next(currentOrder);
            }

            taskList.delMax();
        } 
        else revert(130, "The key does not exists");
    }

    function closeTask(int8 key) public checkOwnerAndAccept {
        if (taskList.exists(key)) {
            task currentTask = taskList.at(key);

            currentTask.complete = true;
            taskList.replace(key, currentTask);
        } 
        else revert(130, "The key does not exists");
    }
}
