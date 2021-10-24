pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract RacquetToken {

    struct Racquet {
        string name;
        uint weight;
        uint balance;
    }
    Racquet[] racquetArray;
    mapping(string => uint) racquetToOwner;
    mapping(string => uint) racquetToPrice;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept(string name) {
        require(msg.pubkey() == racquetToOwner[name], 101);
        tvm.accept();
        _;
    }

    function createRacquet(string name, uint weight, uint balance) public {
        tvm.accept();
        require(racquetToOwner.exists(name) == false, 130, "Racquet name must be unique!");

        racquetArray.push(Racquet(name, weight, balance));
        racquetToOwner[name] = msg.pubkey();
    }

    function getRacquetInfo(string racquetName) public view returns (string name, uint weight, uint balance) {
        require(racquetToOwner.exists(racquetName), 130, "This racquet does not exist!");

        for (Racquet racquet : racquetArray) {
            if (racquet.name == racquetName) {
                name = racquetName;
                weight = racquet.weight;
                balance = racquet.balance;
            }
        }
    }

    function getRacquetPrice(string name) public view returns (uint price) {
        require(isForSale(name), 130, "Racquet must be for sale!");

        optional(uint) racquetPrice = racquetToPrice.fetch(name);
        price = racquetPrice.get();
    }

    function putUpForSale(string name, uint price) public checkOwnerAndAccept(name) {
        racquetToPrice[name] = price;
    }

    function changeOwner(string name, uint pubkeyOfNewOwner) public checkOwnerAndAccept(name) {
        racquetToOwner[name] = pubkeyOfNewOwner;
    }

    function isForSale(string name) public view returns (bool) {
        return (racquetToPrice.exists(name));
    }

}
