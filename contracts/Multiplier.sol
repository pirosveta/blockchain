pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Multiplier {

	uint public product = 1;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	function mul(int value) public checkOwnerAndAccept {
		require((1 <= value && value <= 10), 130, "The value must be in the range from 1 to 10");
		product *= uint(value);
	}
}