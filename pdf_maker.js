import React, { useState } from 'react';
import { FileDown, CheckCircle, Download } from 'lucide-react';

export default function RapidoProposalPDF() {
  const [generating, setGenerating] = useState(false);
  const [generated, setGenerated] = useState(false);

  const generatePDF = () => {
    setGenerating(true);
    
    try {
      const content = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Rapido App Proposal</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 900px;
      margin: 0 auto;
      padding: 20px;
      background: white;
    }
    .header {
      text-align: center;
      border-bottom: 3px solid #FFD700;
      padding-bottom: 20px;
      margin-bottom: 30px;
    }
    .header h1 {
      color: #1a1a1a;
      font-size: 32px;
      margin: 0 0 15px 0;
    }
    .header p {
      color: #666;
      font-size: 16px;
      margin: 8px 0;
    }
    h2 {
      color: #1a1a1a;
      border-left: 5px solid #FFD700;
      padding-left: 15px;
      margin-top: 40px;
      font-size: 24px;
    }
    h3 {
      color: #333;
      font-size: 18px;
      margin-top: 25px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: left;
    }
    th {
      background-color: #FFD700;
      color: #1a1a1a;
      font-weight: bold;
    }
    tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    .highlight {
      background-color: #fff9e6;
      padding: 20px;
      border-left: 5px solid #FFD700;
      margin: 20px 0;
    }
    ul, ol {
      margin: 15px 0;
      padding-left: 30px;
    }
    li {
      margin: 10px 0;
    }
    .footer {
      text-align: center;
      margin-top: 50px;
      padding-top: 20px;
      border-top: 2px solid #ddd;
      font-size: 14px;
      color: #666;
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>🚀 Rapido App Development Proposal</h1>
    <p><strong>Budget Range:</strong> ₹10-15 Lakhs</p>
    <p><strong>Technology Stack:</strong> Flutter, .NET, Python, Node.js</p>
    <p><strong>Timeline:</strong> 5-6 Months</p>
  </div>

  <h2>Executive Summary</h2>
  <p>This proposal outlines a comprehensive plan to develop a ride-hailing platform similar to Rapido, focusing on bike taxi services. The project will leverage modern technologies including Flutter for cross-platform mobile development, Node.js for scalable backend services, .NET for microservices architecture, and Python for AI/ML-powered features.</p>
  
  <p>The platform will consist of three main components: a Customer App for ride booking, a Captain App for drivers, and an Admin Panel for operations management. With a budget range of ₹10-15 lakhs, we will deliver a market-ready product within 5-6 months.</p>
  
  <div class="highlight">
    <strong>Key Deliverables:</strong>
    <ul>
      <li>Cross-platform mobile applications (iOS & Android)</li>
      <li>Real-time GPS tracking and ride matching</li>
      <li>Integrated payment gateway with multiple options</li>
      <li>AI-powered surge pricing and route optimization</li>
      <li>Comprehensive admin dashboard</li>
      <li>Scalable cloud infrastructure</li>
    </ul>
  </div>

  <h2>1. Project Overview</h2>
  
  <h3>Customer App (Flutter)</h3>
  <ul>
    <li>User registration aur login (Phone OTP, Google, Facebook)</li>
    <li>Real-time bike/auto booking</li>
    <li>Live tracking with GPS</li>
    <li>Multiple payment options (UPI, Wallet, Cash, Cards)</li>
    <li>Ride history aur invoices</li>
    <li>Rating aur review system</li>
    <li>Referral program</li>
    <li>In-app customer support chat</li>
  </ul>

  <h3>Captain App (Flutter)</h3>
  <ul>
    <li>Driver onboarding aur verification</li>
    <li>Accept/reject ride requests</li>
    <li>Navigation integration (Google Maps)</li>
    <li>Earnings dashboard</li>
    <li>Daily/weekly payout details</li>
    <li>Availability toggle (online/offline)</li>
    <li>Trip history aur analytics</li>
  </ul>

  <h3>Admin Panel (Web)</h3>
  <ul>
    <li>User management</li>
    <li>Driver verification aur approval</li>
    <li>Real-time monitoring dashboard</li>
    <li>Payment aur commission management</li>
    <li>Analytics aur reports</li>
    <li>Promotional campaigns</li>
    <li>Customer support ticket system</li>
    <li>Geo-fencing aur pricing management</li>
  </ul>

  <h2>2. Technology Stack</h2>
  
  <table>
    <tr>
      <th>Component</th>
      <th>Technology</th>
      <th>Purpose</th>
    </tr>
    <tr>
      <td>Mobile Apps</td>
      <td>Flutter</td>
      <td>Cross-platform iOS & Android</td>
    </tr>
    <tr>
      <td>Admin Panel</td>
      <td>React.js</td>
      <td>Web Dashboard</td>
    </tr>
    <tr>
      <td>Primary API</td>
      <td>Node.js + Express</td>
      <td>Scalable backend</td>
    </tr>
    <tr>
      <td>Microservices</td>
      <td>.NET Core</td>
      <td>Payment & User management</td>
    </tr>
    <tr>
      <td>AI/ML Services</td>
      <td>Python</td>
      <td>Ride matching, Surge pricing</td>
    </tr>
    <tr>
      <td>Database</td>
      <td>PostgreSQL</td>
      <td>Relational data</td>
    </tr>
    <tr>
      <td>Cache</td>
      <td>Redis</td>
      <td>Real-time data</td>
    </tr>
    <tr>
      <td>Storage</td>
      <td>AWS S3</td>
      <td>File storage</td>
    </tr>
    <tr>
      <td>Real-time</td>
      <td>Socket.io</td>
      <td>Live tracking</td>
    </tr>
    <tr>
      <td>Notifications</td>
      <td>Firebase FCM</td>
      <td>Push notifications</td>
    </tr>
    <tr>
      <td>Maps</td>
      <td>Google Maps API</td>
      <td>Routing & Tracking</td>
    </tr>
    <tr>
      <td>Payment</td>
      <td>Razorpay</td>
      <td>Payment processing</td>
    </tr>
  </table>

  <h2>3. Development Timeline</h2>
  
  <table>
    <tr>
      <th>Phase</th>
      <th>Duration</th>
      <th>Deliverables</th>
    </tr>
    <tr>
      <td>Phase 1: Planning & Design</td>
      <td>3-4 weeks</td>
      <td>Wireframes, UI/UX Design, Architecture</td>
    </tr>
    <tr>
      <td>Phase 2: Backend Development</td>
      <td>6-8 weeks</td>
      <td>APIs, Database, Authentication, Payment</td>
    </tr>
    <tr>
      <td>Phase 3: Mobile App Development</td>
      <td>8-10 weeks</td>
      <td>Customer & Captain Apps</td>
    </tr>
    <tr>
      <td>Phase 4: Admin Panel</td>
      <td>4-5 weeks</td>
      <td>Web Dashboard</td>
    </tr>
    <tr>
      <td>Phase 5: Testing & QA</td>
      <td>3-4 weeks</td>
      <td>Bug fixes, Performance testing</td>
    </tr>
    <tr>
      <td>Phase 6: Deployment & Launch</td>
      <td>2 weeks</td>
      <td>App Store deployment, Server setup</td>
    </tr>
    <tr>
      <th colspan="2">Total Timeline</th>
      <th>5-6 Months</th>
    </tr>
  </table>

  <h2>4. Cost Breakdown</h2>
  
  <h3>Option A: Budget Version (₹10-12 Lakh)</h3>
  <table>
    <tr>
      <th>Category</th>
      <th>Details</th>
      <th>Cost (₹)</th>
    </tr>
    <tr>
      <td>UI/UX Design</td>
      <td>Wireframes, Mockups</td>
      <td>80,000</td>
    </tr>
    <tr>
      <td>Flutter Development</td>
      <td>Customer + Captain App</td>
      <td>2,50,000</td>
    </tr>
    <tr>
      <td>Backend Development</td>
      <td>Node.js APIs, Python ML</td>
      <td>2,50,000</td>
    </tr>
    <tr>
      <td>Admin Panel</td>
      <td>React Dashboard</td>
      <td>1,00,000</td>
    </tr>
    <tr>
      <td>Payment Integration</td>
      <td>Razorpay/Paytm setup</td>
      <td>40,000</td>
    </tr>
    <tr>
      <td>Google Maps API</td>
      <td>Integration + credits</td>
      <td>50,000</td>
    </tr>
    <tr>
      <td>Cloud Hosting (6 months)</td>
      <td>AWS/GCP</td>
      <td>60,000</td>
    </tr>
    <tr>
      <td>Testing & QA</td>
      <td>Manual + Automated</td>
      <td>80,000</td>
    </tr>
    <tr>
      <td>App Store Fees</td>
      <td>Google Play + Apple</td>
      <td>25,000</td>
    </tr>
    <tr>
      <td>Project Management</td>
      <td>Coordination</td>
      <td>50,000</td>
    </tr>
    <tr>
      <td>Contingency (10%)</td>
      <td>Buffer</td>
      <td>1,15,000</td>
    </tr>
    <tr>
      <th colspan="2">TOTAL</th>
      <th>₹11,00,000</th>
    </tr>
  </table>

  <h3>Option B: Premium Version (₹13-15 Lakh)</h3>
  <table>
    <tr>
      <th>Category</th>
      <th>Details</th>
      <th>Cost (₹)</th>
    </tr>
    <tr>
      <td>UI/UX Design</td>
      <td>Premium design</td>
      <td>1,20,000</td>
    </tr>
    <tr>
      <td>Flutter Development</td>
      <td>Feature-rich apps</td>
      <td>3,50,000</td>
    </tr>
    <tr>
      <td>Backend Development</td>
      <td>Microservices</td>
      <td>3,50,000</td>
    </tr>
    <tr>
      <td>.NET Services</td>
      <td>Payment & User services</td>
      <td>1,50,000</td>
    </tr>
    <tr>
      <td>Python ML Services</td>
      <td>Surge pricing, Routes</td>
      <td>1,20,000</td>
    </tr>
    <tr>
      <td>Admin Panel</td>
      <td>Advanced analytics</td>
      <td>1,50,000</td>
    </tr>
    <tr>
      <td>Payment Integration</td>
      <td>Multiple gateways</td>
      <td>60,000</td>
    </tr>
    <tr>
      <td>Google Maps API</td>
      <td>Premium features</td>
      <td>80,000</td>
    </tr>
    <tr>
      <td>Cloud Hosting (1 year)</td>
      <td>Scalable infrastructure</td>
      <td>1,20,000</td>
    </tr>
    <tr>
      <td>Testing & QA</td>
      <td>Comprehensive</td>
      <td>1,20,000</td>
    </tr>
    <tr>
      <td>Security Audit</td>
      <td>Penetration testing</td>
      <td>60,000</td>
    </tr>
    <tr>
      <td>App Store Fees</td>
      <td>Both platforms</td>
      <td>25,000</td>
    </tr>
    <tr>
      <td>Project Management</td>
      <td>Comprehensive</td>
      <td>80,000</td>
    </tr>
    <tr>
      <td>Contingency</td>
      <td>Buffer</td>
      <td>1,15,000</td>
    </tr>
    <tr>
      <th colspan="2">TOTAL</th>
      <th>₹15,00,000</th>
    </tr>
  </table>

  <h2>5. Revenue Model</h2>
  <ol>
    <li><strong>Commission:</strong> Har ride pe 15-20% commission</li>
    <li><strong>Surge Pricing:</strong> Peak hours mein dynamic pricing</li>
    <li><strong>Advertising:</strong> In-app advertisements</li>
    <li><strong>Subscription:</strong> Drivers ke liye monthly plans</li>
    <li><strong>Cancellation Charges:</strong> User/Driver fees</li>
  </ol>

  <h2>6. Team Structure</h2>
  
  <h3>Core Team</h3>
  <ul>
    <li>1 Project Manager</li>
    <li>2 Flutter Developers (Mobile apps)</li>
    <li>2 Backend Developers (Node.js, .NET)</li>
    <li>1 Python Developer (ML algorithms)</li>
    <li>1 Frontend Developer (Admin panel)</li>
    <li>1 UI/UX Designer</li>
    <li>1 QA Engineer</li>
    <li>1 DevOps Engineer (Part-time)</li>
  </ul>

  <h2>7. Post-Launch Support</h2>
  
  <table>
    <tr>
      <th>Service</th>
      <th>Monthly Cost (₹)</th>
    </tr>
    <tr>
      <td>Cloud Hosting</td>
      <td>20,000-30,000</td>
    </tr>
    <tr>
      <td>Google Maps API</td>
      <td>10,000-25,000</td>
    </tr>
    <tr>
      <td>Maintenance & Updates</td>
      <td>40,000-60,000</td>
    </tr>
    <tr>
      <td>Customer Support</td>
      <td>30,000-50,000</td>
    </tr>
    <tr>
      <th>TOTAL</th>
      <th>₹1,00,000-1,65,000/month</th>
    </tr>
  </table>

  <h2>8. Key Success Factors</h2>
  <ol>
    <li><strong>User Experience:</strong> Smooth aur fast app performance</li>
    <li><strong>Driver Onboarding:</strong> Quick verification process</li>
    <li><strong>Safety Features:</strong> SOS button, ride sharing</li>
    <li><strong>Marketing:</strong> Referral programs, launch offers</li>
    <li><strong>Customer Support:</strong> 24/7 helpline</li>
  </ol>

  <h2>9. Risks & Mitigation</h2>
  
  <table>
    <tr>
      <th>Risk</th>
      <th>Mitigation</th>
    </tr>
    <tr>
      <td>High Google Maps cost</td>
      <td>Mapbox integration backup</td>
    </tr>
    <tr>
      <td>Driver shortage</td>
      <td>Attractive incentives</td>
    </tr>
    <tr>
      <td>Payment failures</td>
      <td>Multiple payment options</td>
    </tr>
    <tr>
      <td>Competition</td>
      <td>Unique features, better pricing</td>
    </tr>
    <tr>
      <td>Technical bugs</td>
      <td>Thorough testing</td>
    </tr>
  </table>

  <h2>10. Next Steps</h2>
  <ol>
    <li><strong>Requirement Finalization:</strong> Detailed feature list</li>
    <li><strong>Team Hiring:</strong> Development team selection</li>
    <li><strong>Design Phase:</strong> UI/UX mockups approval</li>
    <li><strong>Development Kickoff:</strong> Sprint planning</li>
    <li><strong>Beta Testing:</strong> Limited user testing</li>
    <li><strong>Official Launch:</strong> Marketing campaign</li>
  </ol>

  <h2>Conclusion</h2>
  <p>This comprehensive proposal presents a viable roadmap for developing a Rapido-like ride-hailing platform within a budget of ₹10-15 lakhs. By leveraging modern technologies like Flutter for cross-platform development, Node.js for scalable APIs, .NET for microservices, and Python for AI/ML capabilities, we will create a robust and market-competitive solution.</p>
  
  <p>The proposed timeline of 5-6 months is realistic and allows for thorough development, testing, and deployment across all three major components: Customer App, Captain App, and Admin Panel. The modular architecture ensures scalability, while the carefully planned technology stack guarantees optimal performance and future-readiness.</p>
  
  <div class="highlight">
    <strong>Expected Outcomes:</strong>
    <ul>
      <li>A fully functional, market-ready ride-hailing platform</li>
      <li>Cross-platform mobile apps with seamless user experience</li>
      <li>Real-time tracking and AI-powered ride matching</li>
      <li>Secure payment integration with multiple options</li>
      <li>Comprehensive admin dashboard for operations management</li>
      <li>Scalable cloud infrastructure to support growth</li>
    </ul>
  </div>
  
  <p>With proper execution, marketing strategy, and continuous improvement based on user feedback, this platform has strong potential to capture significant market share in the bike taxi segment. The investment in modern technology stack will ensure the platform remains competitive and adaptable to future market demands.</p>
  
  <p><strong>We are confident that this project will deliver exceptional value and ROI within the proposed budget and timeline.</strong></p>

  <div class="footer">
    <p>© 2024 Rapido App Development Proposal | Confidential Document</p>
    <p>Technology Stack: Flutter, .NET, Python, Node.js</p>
  </div>
</body>
</html>
      `;

      // Create blob and download
      const blob = new Blob([content], { type: 'text/html' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'Rapido_App_Proposal.html';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
      
      setGenerated(true);
      setGenerating(false);
      
    } catch (error) {
      console.error('Error generating PDF:', error);
      alert('PDF generate karne mein error aaya. Please try again.');
      setGenerating(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-yellow-50 via-orange-50 to-red-50 p-4 sm:p-8">
      <div className="max-w-4xl mx-auto">
        <div className="bg-white rounded-3xl shadow-2xl p-6 sm:p-10">
          
          {/* Header */}
          <div className="text-center mb-8">
            <div className="inline-block bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-6 py-2 rounded-full text-sm font-bold mb-4">
              📄 PROFESSIONAL PROPOSAL GENERATOR
            </div>
            <h1 className="text-3xl sm:text-5xl font-black text-gray-800 mb-4 bg-gradient-to-r from-yellow-600 to-orange-600 bg-clip-text text-transparent">
              Rapido App Proposal
            </h1>
            <p className="text-gray-600 text-lg mb-6">
              Complete project proposal with English Executive Summary & Conclusion
            </p>
            <div className="flex justify-center gap-3 flex-wrap">
              <span className="bg-yellow-100 text-yellow-800 px-4 py-2 rounded-full text-sm font-bold shadow-md">
                💰 Budget: ₹10-15 Lakhs
              </span>
              <span className="bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-bold shadow-md">
                ⏱️ Timeline: 5-6 Months
              </span>
              <span className="bg-green-100 text-green-800 px-4 py-2 rounded-full text-sm font-bold shadow-md">
                💻 Flutter + .NET + Python + Node.js
              </span>
            </div>
          </div>

          {/* Features Box */}
          <div className="bg-gradient-to-br from-yellow-50 to-orange-50 rounded-2xl p-6 mb-8 border-2 border-yellow-200">
            <h2 className="text-2xl font-bold text-gray-800 mb-4 flex items-center gap-2">
              <CheckCircle className="w-6 h-6 text-green-600" />
              📋 Document Contents
            </h2>
            <div className="grid sm:grid-cols-2 gap-3">
              {[
                'Executive Summary (English)',
                'Complete Project Overview',
                'Technology Stack Details',
                'Development Timeline',
                'Cost Breakdown (2 Options)',
                'Revenue Model',
                'Team Structure',
                'Post-Launch Support',
                'Risk Analysis',
                'Conclusion (English)'
              ].map((item, index) => (
                <div key={index} className="flex items-start gap-2 bg-white p-3 rounded-lg shadow-sm">
                  <CheckCircle className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
                  <span className="text-gray-700 text-sm font-medium">{item}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Download Button */}
          <div className="text-center mb-8">
            <button
              onClick={generatePDF}
              disabled={generating}
              className={`
                inline-flex items-center gap-3 px-10 py-5 rounded-2xl text-xl font-bold
                transition-all transform hover:scale-105 shadow-2xl
                ${generating 
                  ? 'bg-gray-400 cursor-not-allowed' 
                  : generated
                  ? 'bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700'
                  : 'bg-gradient-to-r from-yellow-500 via-orange-500 to-red-500 hover:from-yellow-600 hover:via-orange-600 hover:to-red-600'
                }
                text-white
              `}
            >
              {generating ? (
                <>
                  <div className="animate-spin rounded-full h-7 w-7 border-b-3 border-white"></div>
                  Generating...
                </>
              ) : generated ? (
                <>
                  <CheckCircle className="w-7 h-7" />
                  Downloaded! Click to Download Again
                </>
              ) : (
                <>
                  <Download className="w-7 h-7 animate-bounce" />
                  Download Complete Proposal
                </>
              )}
            </button>
          </div>

          {/* Instructions */}
          <div className="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl p-6 border-2 border-blue-200">
            <h3 className="font-bold text-blue-900 mb-4 text-xl flex items-center gap-2">
              📌 How to Use
            </h3>
            <ol className="space-y-3 text-blue-800">
              <li className="flex items-start gap-3">
                <span className="bg-blue-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold flex-shrink-0">1</span>
                <span>Click the "Download Complete Proposal" button above</span>
              </li>
              <li className="flex items-start gap-3">
                <span className="bg-blue-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold flex-shrink-0">2</span>
                <span>An HTML file will be downloaded to your computer</span>
              </li>
              <li className="flex items-start gap-3">
                <span className="bg-blue-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold flex-shrink-0">3</span>
                <span>Open the HTML file in any web browser (Chrome, Firefox, etc.)</span>
              </li>
              <li className="flex items-start gap-3">
                <span className="bg-blue-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold flex-shrink-0">4</span>
                <span>Press Ctrl+P (Windows) or Cmd+P (Mac) to print</span>
              </li>
              <li className="flex items-start gap-3">
                <span className="bg-blue-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm font-bold flex-shrink-0">5</span>
                <span>Select "Save as PDF" and download your professional proposal!</span>
              </li>
            </ol>
          </div>

          {/* Footer Info */}
          <div className="mt-8 text-center space-y-2">
            <p className="text-gray-600 font-medium">✨ Professional formatting with tables, headers & styling</p>
            <p className="text-gray-600 font-medium">🌐 Executive Summary & Conclusion in English</p>
            <p className="text-gray-600 font-medium">📊 Complete cost breakdown & timeline included</p>
          </div>

        </div>
      </div>
    </div>
  );
}