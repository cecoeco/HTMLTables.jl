const puppeteer = require("puppeteer");

/**
 * Convert HTML string with table and styling to PDF document using Puppeteer
 * @param {string} htmlString - HTML content string with table and styling to convert to document
 * @param {string} outputPath - Path to save the PDF document
 */
async function html2pdf(htmlString, outputPath) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  await page.setContent(htmlString, { waitUntil: "networkidle0" });
  await new Promise((resolve) => setTimeout(resolve, 1000));

  const pdfOptions = {
    path: outputPath,
    printBackground: true,
  };

  await page.pdf(pdfOptions);
  await browser.close();
}
