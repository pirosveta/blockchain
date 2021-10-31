pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'BaseStation.sol';

abstract contract MilitaryUnit is GameObject {

    BaseStation public baseStation;

    function getAttackPower() virtual public returns (int);

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    function attack(GameObject gameObjectForAttack) public checkOwnerAndAccept {
        gameObjectForAttack.takeAttack(
            getAttackPower()
        );
    }

    function deathHandling() public override {
        tvm.accept();
        kill();
    }

    function killByBase(address sender) public override {
        tvm.accept();
        sender.transfer(1, true, 160);
    }

}
