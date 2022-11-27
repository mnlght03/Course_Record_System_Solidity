// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./Admin.sol";

contract AdminList {
  Administrator[] public admins;
  mapping (address => uint) public adminId;

  function addAdmin(address newAdmin) public {
    require(newAdmin != address(0));
    admins.push(new Administrator(newAdmin, admins.length + 1));
    adminId[newAdmin] = admins.length;
  }

  function getAdminIdx(address admin) public view returns (uint) {
    require(admin != address(0));
    require(adminId[admin] > 0, "AdminList.getAdminIdx: admin doesn't exist");
    return adminId[admin] - 1;
  }

  function deleteAdmin(address admin) public {
    delete admins[getAdminIdx(admin)];
    delete adminId[admin];
  }
}