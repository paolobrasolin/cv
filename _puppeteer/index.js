#!/usr/bin/env node

const puppeteer = require("puppeteer");
// NOTE: remember to install missing dependencies.
// https://gist.github.com/winuxue/cfef08e2f5fe9dfc16a1d67a4ad38a01
// libatk-bridge2.0-0 libxkbcommon-x11-0 libgbm-dev

const yargs = require('yargs/yargs')
const { hideBin } = require('yargs/helpers')

const argv = yargs(hideBin(process.argv))
  .option('source', { describe: 'address of HTML source' })
  .option('target', { describe: 'path of PDF output' })
  .demandOption(['source', 'target'])
  .argv;

(async () => {
  const browser = await puppeteer.launch({
    args: ["--allow-file-access-from-files", "--enable-local-file-accesses"],
  });
  const page = await browser.newPage();
  await page.goto(argv.source, { waitUntil: "networkidle2" });
  await page.pdf({ path: argv.target, format: "a4" });
  await browser.close();
})();

