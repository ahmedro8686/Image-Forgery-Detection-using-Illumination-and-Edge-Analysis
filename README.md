Image Forgery Detection using Illumination and Edge Analysis

📌 Overview

This MATLAB project detects potential forged or manipulated regions in digital images by analyzing illumination inconsistencies, edge structures, and statistical anomalies.
The method combines multiple image processing techniques to highlight suspicious areas and generate a detailed report.


---

🛠 Features

Illumination Map Analysis – Detects unnatural lighting variations.

Edge Detection – Finds sharp and unusual boundaries.

Z-score Statistical Analysis – Identifies abnormal pixel values across features.

Automatic or Manual Thresholding – Uses Otsu’s method or a fixed threshold.

Noise Removal – Eliminates small irrelevant regions.

Region Property Extraction – Calculates area, centroid, bounding box, and more.

Multiple Output Formats – Saves results as annotated images, overlays, and summary grids.

Detailed Report Generation – Exports a text file with all analysis parameters and statistics.



---

📂 Project Structure

/project-folder
│
├── main.m                # Main script to run the analysis  
├── results/              # Generated output images and reports  
├── sample_image.jpg      # Example input image  
└── README.md             # Project documentation


---

🚀 How to Run

1. Open MATLAB.


2. Place your image file in the project folder.


3. Update the image filename inside main.m if needed.


4. Run:

main


5. Results will be saved in the results folder.




---

📊 Output Examples

Illumination Map – Shows brightness distribution.

Edge Map – Highlights boundaries.

Anomaly Map (Z-score) – Displays suspicious pixels.

Annotated Image – Marks detected regions with bounding boxes.

Overlay Image – Transparent red overlay on suspicious areas.

Text Report – Summarizes analysis results.


(You can replace the placeholders below with your actual output images)




---

📄 Report Example

Image Forgery Detection Report
==============================
Image file: sample_image.jpg
Timestamp: 2025-08-09

Parameters:
  Gaussian sigma: 2
  Local window size: 15
  Use Otsu threshold: 1

Results summary:
  Total pixels: 921600
  Anomalous pixels: 13245
  Percent anomalous: 1.4375 %
  Number of detected regions: 3

Regions (index, area, centroid_x, centroid_y):
  1, 823, 245.50, 130.75
  2, 1214, 356.80, 287.40
  3, 410, 489.22, 320.10


---

📜 License

This project is released under the MIT License – you are free to use, modify, and distribute it with attribution.


---

👤 Author

Ahmed Mohamed El-Sayed Mohamed
📧 Email: ahmed.2024zsc@gmail.com
