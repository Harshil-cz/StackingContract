// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Token.sol";

contract Stackingcontract is ERC721, Ownable {
    
    MyToken token;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(address=>uint) time;  //for user's stacking time.
    mapping(address=>uint) value; //for user's stacking value.
    mapping(address=>bool) check; //to check user put ether on stack or not.

    constructor(address _tokenAddress) ERC721("Diamond", "dmd") {
        token = MyToken(_tokenAddress);
    }

    //for stacking ether to contract
    receive() external payable {
        time[msg.sender]=block.timestamp;
        value[msg.sender]=msg.value;
        check[msg.sender]=true;
    }

    //for withdraw stacking amount and getting reward of stacking. 
    function withdraw() public {
        require(block.timestamp>(time[msg.sender]+1 minutes),"Stacking Time not over.");
        require(check[msg.sender]==true,"you have to put ether on stack.");
        payable(msg.sender).transfer(value[msg.sender]);
        uint _time=1 minutes;
        uint count;

        for(uint i=1;i>0;i++){
            if(block.timestamp>(time[msg.sender]+(_time*i))){
                count+=1;
            }
            else{
                break;
            }
        }

        token.mint(msg.sender,((5*value[msg.sender])/100)*count);
        check[msg.sender]=false;
        // value[msg.sender]=0;
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender,tokenId);
    }
}


// IERC20 public tokenAddress;

// tokenAddress=IERC20(_tokenAddress);

// tokenAddress.mint(msg.sender,(5*value[msg.sender])/100);