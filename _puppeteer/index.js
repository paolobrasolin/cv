"use strict";

const puppeteer = require("puppeteer");

// NOTE: remember to install missing dependencies.
// https://gist.github.com/winuxue/cfef08e2f5fe9dfc16a1d67a4ad38a01
// libatk-bridge2.0-0 libxkbcommon-x11-0 libgbm-dev

(async () => {
  const browser = await puppeteer.launch({
    args: ["--allow-file-access-from-files", "--enable-local-file-accesses"],
  });
  const page = await browser.newPage();
  await page.goto(`file://${__dirname}/../_site/index.html`, {
    waitUntil: "networkidle2",
  });
  await page.pdf({
    path: `${__dirname}/../assets/paolo-brasolin-cv.pdf`,
    format: "a4",
  });

  await browser.close();
})();
