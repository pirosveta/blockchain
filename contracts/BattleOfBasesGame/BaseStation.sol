pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';

contract BaseStation is GameObject {

    int private defensePower = 6;
    address[] public units;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function getDefensePower() public override returns (int) {
        return defensePower;
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    function addUnit(address unitForInsert) public checkOwnerAndAccept {
        for (address unit : units) {
            require(unit != unitForInsert, 130, "Such military unit already exist!");
        }

        units.push(unitForInsert);
    }

    function deleteUnit(address unitForDelete) public checkOwnerAndAccept {
        uint indexForDelete = units.length;

        for (uint index = 0; index < units.length; index++) {
            if (units[index] == unitForDelete) {
                indexForDelete = index;
                break;
            }
        }
        require(indexForDelete < units.length, 130, "Such military unit does not exist!");

        for (uint index = indexForDelete; index < units.length - 1; index++) {
            units[index] = units[index + 1];
        }
        units.pop();
    }

    function deathHandling() public override {
        tvm.accept();
        for (address unit : units) {
            GameObject(unit).killByBase(msg.sender);
        }
        kill();
    }

    function killByBase(address sender) public override{}
}
