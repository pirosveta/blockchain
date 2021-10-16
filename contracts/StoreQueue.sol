
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract StoreQueue {

    string[] public peopleInQueue;

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

    function toGetInQueue(string personName) public checkOwnerAndAccept {
        require(personName != "", 130, "Person name must not be empty");
        peopleInQueue.push(personName);
    }

    function callNext() public checkOwnerAndAccept returns(string servedPerson) {
        if (peopleInQueue.length > 0) {
            string servedPerson = peopleInQueue[0];
            for (uint index = 1; index < peopleInQueue.length; index++) {
                peopleInQueue[index - 1] = peopleInQueue[index];
            }
            peopleInQueue.pop();

            return servedPerson;
        } else return "";
    }
}
