pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObjectInterface.sol';

abstract contract GameObject is GameObjectInterface {

    int public lives = 20;

    function getDefensePower() virtual public override returns (int);

    function takeAttack(int attackPower) public override {
        tvm.accept();
        int attackEfficiency = attackPower - getDefensePower();
        if (attackEfficiency > 0) {
            lives -= attackEfficiency;
        }
        if (isKilled()) {
            deathHandling();
        }
    }

    function isKilled() private returns (bool) {
        tvm.accept();
        return (lives <= 0);
    }

    function deathHandling() virtual public {
        tvm.accept();
        kill();
    }

    function kill() internal {
        tvm.accept();
        msg.sender.transfer(1, true, 160);
    }

    function killByBase(address sender) virtual public;
}
