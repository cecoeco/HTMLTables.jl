const fs = require("fs");
const puppeteer = require("puppeteer");

/**
 * Convert HTML string with table and styling to PNG image using Puppeteer
 * @param {string} htmlString - HTML content string with table and styling to convert to image
 * @param {string} outputPath - Path to save the PNG image
 */
async function html2png(htmlString, outputPath) {
  try {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    await page.goto(
      `data:text/html;charset=utf-8,${encodeURIComponent(htmlString)}`,
      { waitUntil: "domcontentloaded" }
    );

    const pngBuffer = await page.screenshot({ fullPage: true });

    fs.writeFileSync(outputPath, pngBuffer);

    console.log("Image saved:", outputPath);

    await browser.close();
  } catch (error) {
    console.error("Error:", error);
  }
}
