// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract TestSwap {

  uint256 x;
  uint256 y;
  uint256 k;

  constructor(uint256 x0, uint256 y0) {
    x = x0;
    y = y0;
    k = x * y;
  }

  function getX() public view returns (uint256){
    return x;
  }

  function getY() public view returns (uint256){
    return y;
  }

  event Swap(uint256 x, uint256 y, uint256 dx, uint256 dy);

  function swap(uint256 dx) public returns (uint256) {
      uint256 newx = x + dx;
      // (y - dy) * (x + dx) = k = x * y
      uint256 newy = x * y / (x + dx);
      uint256 dy = y - newy;
      x = newx;
      y = newy;
      emit Swap(x,y,dx,dy);
      return dy;
  }

  // uint256 favoriteNumber;

  // struct People {
  //   uint256 favoriteNumber;
  //   string name;
  // }

  // // uint256[] public anArray;
  // People[] public people;

  // mapping(string => uint256) public nameToFavoriteNumber;

  // function store(uint256 _favoriteNumber) public {
  //   favoriteNumber = _favoriteNumber;
  // }

  // function retrieve() public view returns (uint256) {
  //   return favoriteNumber;
  // }

  // function addPerson(string memory _name, uint256 _favoriteNumber) public {
  //   people.push(People(_favoriteNumber, _name));
  //   nameToFavoriteNumber[_name] = _favoriteNumber;
  // }
}
