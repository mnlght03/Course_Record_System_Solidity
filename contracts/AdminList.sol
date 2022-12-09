// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./Administrator.sol";

contract AdminList {
  Administrator[] public admins;
  mapping (address => uint) public adminId;

  function adminExists(address admin) public view returns (bool) {
    if (admin == address(0) || adminId[admin] == 0)
      return false;
    return true;
  }

  function addAdmin(address newAdmin) public {
    require(newAdmin != address(0), "Admin address is zero");
    require(!adminExists(newAdmin), "Admin already exists");
    admins.push(new Administrator(newAdmin, admins.length + 1));
    adminId[newAdmin] = admins.length;
  }

  function getAdminIdx(address admin) public view returns (uint) {
    require(adminExists(admin), "Admin doesn't exist");
    return adminId[admin] - 1;
  }

  function deleteAdmin(address admin) public {
    require(adminExists(admin), "Admin doesn't exist");
    delete admins[getAdminIdx(admin)];
    delete adminId[admin];
  }
}