pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'MilitaryUnit.sol';
import 'BaseStation.sol';

contract Acrher is MilitaryUnit {

    int private attackPower = 5;
    int private defensePower = 2;

    constructor(BaseStation station) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();

        station.addUnit(address(this));
        baseStation = station;
    }

    function getAttackPower() public override returns (int) {
        tvm.accept();
        return attackPower;
    }

    function getDefensePower() public override returns (int) {
        tvm.accept();
        return defensePower;
    }
}
