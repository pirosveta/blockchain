pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface GameObjectInterface {
    function takeAttack(int attackPower) external;
    function getDefensePower() external returns (int);
}