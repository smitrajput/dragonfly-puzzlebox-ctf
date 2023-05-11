pragma solidity ^0.8.19;

import "./PuzzleBox.sol";

contract CleanPuzzleBoxSolution {
    // uint256 constant S_THRESHOLD = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;

    function solve(PuzzleBox puzzle) external {
        // How close can you get to opening the box?

        Operate operate = new Operate(puzzle);
        operate.callDrip();

        puzzle.leak();
        // address(uint160(address(puzzle)) + uint160(2)) = 0x037EDA3AdB1198021A9B2e88C22B464Fd38DB3f5
        payable(address(uint160(address(puzzle)) + uint160(2))).transfer(1);
        puzzle.zip();

        puzzle.creep{gas: 98000}();

        uint256[] memory n = new uint256[](6);
        assembly {
            mstore(add(n, 0x20), 2)
            mstore(add(n, 0x40), 4)
            mstore(add(n, 0x60), 6)
            mstore(add(n, 0x80), 7)
            mstore(add(n, 0xa0), 8)
            mstore(add(n, 0xc0), 9)
        }
        bytes memory encodedDripIds = abi.encode(n);

        address(puzzle).call(abi.encodePacked(
                            puzzle.torch.selector, uint256(0x01), uint8(0), encodedDripIds));

        address payable[] memory friends = new address payable[](1);
        uint256[] memory friendsCutBps = new uint256[](3);
        assembly {
            mstore(add(friends, 0x20), 0x416e59DaCfDb5D457304115bBFb9089531D873B7)
            mstore(add(friendsCutBps, 0x20), 0x00C817dD2a5daA8f790677e399170c92AabD044b57)
            mstore(add(friendsCutBps, 0x40), 150)
            mstore(add(friendsCutBps, 0x60), 75)
        }

        puzzle.spread(friends, friendsCutBps);

        uint256 nonce = 0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8;
        // uint256 r = uint256(0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8);
        // S_THRESHOLD - uint256(0x625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df)
        // = 71301600283128936764672812745529451294904726341347593422192209434084996057698
        uint256 s = 71301600283128936764672812745529451294904726341347593422192209434084996057698;
        uint8 v = 27;
        //= abi.encodePacked(nonce, s, v);
        bytes memory sign = abi.encodePacked(nonce, s, v);
        // assembly {
        //     mstore(add(sign, 0x20), nonce)
        //     mstore(add(sign, 0x40), s)
        //     mstore(add(sign, 0x60), v)
        // }
        puzzle.open(nonce, sign);
    }
}

interface IPBProxy {
    function lock(bytes4, bool) external;
}

contract Operate {
    PuzzleBox immutable puzzle;
    address immutable solution;
    constructor(PuzzleBox _puzzle) payable {
        puzzle = _puzzle;
        solution = msg.sender;
        puzzle.operate();
        // bytes4(keccak256("torch(bytes)") = 0x41c0e1a1
        // puzzle.torch.selector
        IPBProxy(address(puzzle)).lock(puzzle.torch.selector, false);
    }

    function callDrip() external {
        puzzle.drip{value: 101}();
    }

    receive() external payable {
        if(address(this).balance != 337) {
            puzzle.drip{value: 101}();
        } else {
            selfdestruct(payable(solution));
        }
    }
}

        // friends[0] = payable(0x416e59DaCfDb5D457304115bBFb9089531D873B7);
        // uint160(bytes20(0xC817dD2a5daA8f790677e399170c92AabD044b57))
        // 0xC817dD2a5daA8f790677e399170c92AabD044b57 -> not implicitly convertible to uint256, but
        // 0x00C817dD2a5daA8f790677e399170c92AabD044b57 is. Strange.
        // friendsCutBps[0] = 0x00C817dD2a5daA8f790677e399170c92AabD044b57;
        // friendsCutBps[1] = 150;
        // friendsCutBps[2] = 75;

        // address sol = solution;
        // bytes4 fnSig = hex"19ae45e4";
        // assembly {
        //     mstore(0x00, fnSig)
        //     switch eq(selfbalance(), 337)
        //     case 0 {
        //         pop(
        //             call(gas(), caller(), 101, 0x00, 4, 0x20, 0x20)
        //         )
        //     }
        //     case 1 {
        //         selfdestruct(sol)
        //     }
        // }