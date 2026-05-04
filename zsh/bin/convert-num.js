#!/usr/bin/env node
// SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
// Repository: https://github.com/charlie-wong/charlie-wong

function usage() {
  console.log("进制转换 convert-num.js hex=ab");
  console.log("进制转换 convert-num.js dec=12");
  console.log("进制转换 convert-num.js oct=34");
  console.log("进制转换 convert-num.js bin=10");
  process.exit(0);
}

// node 脚本名 参数
if(process.argv.length != 3) {
  usage();
}

const what = process.argv[2].split("=");

if(what[0] == "bin") {
  console.log("BIN=" + parseInt(what[1], 2).toString(2));
  console.log("OCT=" + parseInt(what[1], 2).toString(8));
  console.log("DEC=" + parseInt(what[1], 2).toString(10));
  console.log("HEX=" + parseInt(what[1], 2).toString(16));

} else if(what[0] == "oct") {
  console.log("BIN=" + parseInt(what[1], 8).toString(2));
  console.log("OCT=" + parseInt(what[1], 8).toString(8));
  console.log("DEC=" + parseInt(what[1], 8).toString(10));
  console.log("HEX=" + parseInt(what[1], 8).toString(16));
} else if(what[0] == "dec") {
  console.log("BIN=" + parseInt(what[1], 10).toString(2));
  console.log("OCT=" + parseInt(what[1], 10).toString(8));
  console.log("DEC=" + parseInt(what[1], 10).toString(10));
  console.log("HEX=" + parseInt(what[1], 10).toString(16));
} else if(what[0] == "hex") {
  console.log("BIN=" + parseInt(what[1], 16).toString(2));
  console.log("OCT=" + parseInt(what[1], 16).toString(8));
  console.log("DEC=" + parseInt(what[1], 16).toString(10));
  console.log("HEX=" + parseInt(what[1], 16).toString(16));
}

process.exit(0);
