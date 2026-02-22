# Win Fatafat Requirements Document

## 1. Application Overview

### 1.1 Application Name
Win Fatafat

### 1.2 Application Description
A fully functional, production-ready web application for Kolkata Fatafat betting with comprehensive admin control, wallet management, and real-time synchronization. The system includes three main components: User App, Admin Panel, and Assistance/Sub-Admin Panel.

### 1.3 Target Audience
- Indian UPI users
- Kolkata Fatafat players
- Wallet-based betting operators
- Small admin-controlled gaming platforms

### 1.4 Design Requirements
- Material Design with Android app feel
- Card-based layout with ripple effects
- Smooth animations and soft shadows
- Rounded UI elements
- Sliding drawer navigation
- Premium color theme
- Dark and Light mode ready
- Professional typography
- Mobile-first responsive design
- Touch optimized interface

### 1.5 Language Requirement
- Default language: English
- All interface text, labels, buttons, and messages in English

## 2. User Authentication System

### 2.1 Signup
- Registration using mobile number and password
- No OTP verification required
- Mobile number must be unique
- Duplicate accounts with same number not allowed
- Auto-generated unique User ID upon registration

### 2.2 Login
- Secure login using mobile number and password

### 2.3 Settings Page
- Change Password functionality
- Logout option
- Accessible via navigation menu

### 2.4 Change Password
- Current password verification required
- New password entry
- Confirm password field
- Password change only allowed with correct current password
- Available in User App Settings

### 2.5 Admin Access to User Credentials
- Admin can view user mobile numbers
- Admin can view current passwords
- Full admin control over user accounts

## 3. User App Core Features

### 3.1 Navigation
- 3-line hamburger navigation menu
- Added Bet History option in navigation menu
- Added Settings option in navigation menu

### 3.2 Dashboard
- Display wallet balance
- User wallet balance automatically updated every 1 second
- Display User ID
- Status cards for quick information

### 3.3 Add Money (Manual Recharge)
- Dynamic QR code display (admin controlled)
- UTR submission for payment verification
- Recharge status tracking
- Minimum recharge: ₹300 (admin editable)

### 3.4 Withdrawal System
- Withdrawal methods: UPI and Bank Transfer
- Withdrawal details required:
  - UPI ID
  - Bank Account Number
  - IFSC Code
  - Account Holder Name
  - Bank Name
- Minimum withdrawal: ₹500 (admin editable)
- Maximum withdrawal limit (admin editable)
- Daily withdrawal limit: 2 withdrawals per day (admin editable)
- Saturday withdrawal limit: 1 withdrawal (admin editable)
- Sunday withdrawal: No withdrawals allowed
- Withdrawal tax: 2% deducted from every withdrawal (admin can enable/disable and change percentage)
- Auto rejection if insufficient balance (including withdrawal tax)
- Auto rejection if daily/weekly limit exceeded
- Auto rejection on Sunday
- Withdrawal history tracking
- Display withdrawal rules in user app
- Display withdrawal tax information in user app
- Withdrawal rules and tax settings dynamically updated when admin changes them
- System must properly track daily withdrawal count and allow exactly 2 withdrawal requests per day when limit is set to 2

### 3.5 Betting History
- Complete record of all bets placed
- Display date and time for each bet
- Win/loss status
- Amount details
- Accessible via navigation menu

### 3.6 Customer Support
- WhatsApp support link (admin editable)

### 3.7 Game Rules Page
- Admin controlled content
- Display game rules and instructions

### 3.8 Real-Time Updates
- Instant synchronization across all modules

## 4. Wallet System

### 4.1 Wallet Rules
- Minimum recharge: ₹300 (admin editable)
- Minimum withdrawal: ₹500 (admin editable)
- Maximum withdrawal limit (admin editable)
- Daily withdrawal limit: 2 withdrawals per day (admin editable)
- Saturday withdrawal limit: 1 withdrawal (admin editable)
- Sunday withdrawal: No withdrawals allowed
- Withdrawal tax: 2% (admin editable and can be enabled/disabled)
- Auto rejection for insufficient balance (including withdrawal tax)
- Auto rejection if daily/weekly limit exceeded
- Auto rejection on Sunday
- Instant deduction on bet placement
- Instant credit on winning

### 4.2 Wallet Operations
- Real-time balance updates
- User wallet balance automatically updated every 1 second
- Transaction history
- Automatic balance validation
- Withdrawal tax calculation and deduction

## 5. Betting System - Kolkata Fatafat

### 5.1 Home Page
- Result Button: Opens admin-added website link
- Play Button: Shows available games

### 5.2 Game Management
- Admin can add multiple games
- Default game: Kolkata Fatafat
- Custom game names supported

### 5.3 Game Time Control
- Admin configurable:
  - Custom game name
  - Custom option name
  - Start time
  - End time
- Display Coming status before start time
- Auto unlock play button at start time
- Auto lock at end time
- Users can only play during active time window

### 5.4 Bet Types

#### Single
- Number range: 0-9
- Minimum bet: ₹10 (admin editable)
- Winning calculation: Admin customizable multiplier
- Example: ₹10 bet with 9x multiplier = ₹90 winning amount
- Example: ₹10 bet with 10x multiplier = ₹100 winning amount

#### Juri
- Number range: 10-99
- Minimum bet: ₹5 (admin editable)

#### Patti
- Number range: 100-999
- Minimum bet: ₹10 (admin editable)

### 5.5 Betting Process
- User enters number and amount
- Click Pay button
- Total bet amount instantly deducted from wallet
- Bet recorded in betting history with date and time

### 5.6 Winning System
- Admin controls:
  - Winning number
  - Winning type (Single/Juri/Patti)
  - Winning multiplier (customizable for each bet type)
  - Admin can change bet winning multiplier at any time
- Winner announcement panel
- System behavior:
  - Matching numbers result in win
  - Winning amount = Bet amount × Admin-set multiplier
  - Non-matching numbers result in loss
  - Pending status auto updates
  - Winning amount instantly credited to wallet
  - Real-time synchronization across all interfaces

## 6. Admin Panel Features

### 6.1 Authentication
- Secure admin login system

### 6.2 Navigation
- 3-line hamburger menu

### 6.3 Recharge Management
- View recharge requests
- Approve or reject recharge requests
- UTR verification

### 6.4 Withdrawal Management
- View withdrawal requests
- Approve or reject withdrawals
- Process payments
- Set maximum withdrawal limit
- Set daily withdrawal limit (default: 2 per day)
- Set Saturday withdrawal limit (default: 1)
- Set Sunday withdrawal status (default: disabled)
- Configure withdrawal tax percentage (default: 2%)
- Enable or disable withdrawal tax
- Edit withdrawal rules
- Changes to withdrawal rules and tax settings instantly reflected in user app
- System must properly enforce daily withdrawal limit (e.g., when set to 2, users can send exactly 2 withdrawal requests per day)

### 6.5 Wallet Manager
- Edit user wallet balance
- View transaction history
- Manual wallet adjustments

### 6.6 User Management
- Search users by User ID
- Delete user accounts
- Freeze user accounts (with proper functionality to prevent frozen users from accessing the system)
- Edit user wallet
- Edit user bets
- View user credentials (mobile number and password)
- View user bet history with date and time

### 6.7 User Pending Bet History Management
- Check user pending bet history
- Edit pending bet history
- Modify pending bet details

### 6.8 Assistance Manager
- Add assistance/sub-admin accounts
- Assign permissions
- Remove permissions
- Permission control system
- View user bet history (with permission)

### 6.9 Game Management
- Add, edit, delete games
- Set game start and end times
- Configure game rules
- Set minimum bet amounts for each bet type
- Set winning multipliers for each bet type (Single/Juri/Patti)
- Set winning numbers
- Change bet winning multiplier at any time
- Winner announcement panel

### 6.10 System Settings
- Set minimum recharge amount
- Set minimum withdrawal amount
- Set maximum withdrawal limit
- Set daily withdrawal limit
- Set Saturday withdrawal limit
- Enable/disable Sunday withdrawals
- Set withdrawal tax percentage
- Enable/disable withdrawal tax
- Change WhatsApp support number
- QR code upload and replace system
- Edit and update withdrawal rules

### 6.11 Statistics Dashboard
- Overview of platform performance
- User statistics
- Transaction statistics
- Betting statistics

### 6.12 Security Settings
- Full security configuration options

## 7. Assistance/Sub-Admin Panel

### 7.1 Role System
- Limited access based on admin-assigned permissions
- View only allowed modules
- Configurable permission levels

### 7.2 Permission Types
- Admin can grant or revoke access
- Permissions assignable to specific modules
- Real-time permission updates
- View user bet history (when permission granted)

## 8. QR Code System

### 8.1 Admin QR Management
- Upload QR code images
- Replace existing QR codes
- Dynamic QR display in user app

### 8.2 User QR Display
- Display current active QR code
- Real-time updates when admin changes QR

## 9. Real-Time Sync Engine

### 9.1 Synchronization Scope
- Instant updates across all user sessions
- Real-time wallet balance updates
- User wallet balance automatically updated every 1 second
- Live betting status updates
- Instant winner announcements
- Real-time game status changes
- Real-time withdrawal rules updates
- Real-time withdrawal tax settings updates

## 10. Security Layer

### 10.1 Security Features
- Secure authentication system
- Input validation
- Data encryption
- Session management
- Access control
- Anti-fraud measures
- Frozen user account enforcement (prevent login and system access for frozen users)

## 11. Technical Requirements

### 11.1 Technology Stack
- HTML5
- CSS3
- Vanilla JavaScript
- Font Awesome Icons
- No frameworks allowed

### 11.2 Performance Requirements
- Optimized DOM manipulation
- Secure validation
- No redundant logic
- Lightweight animations
- Fast loading times

### 11.3 Folder Structure
Separate modules for:
- User App
- Admin Panel
- Assistance Layer
- Wallet Engine
- Betting Engine
- Real-Time Sync Layer
- Security Layer
- Config and Settings

### 11.4 Hosting Compatibility
- InfinityFree compatible structure

## 12. Future Expansion Support

The system architecture must support future additions:
- Referral system
- Bonus wallet
- Cashback system
- Auto result engine
- Leaderboard
- Commission tracking
- Admin profit calculation
- Expandable commission logic
- Ad placement capability

## 13. Development Guidelines

### 13.1 Code Quality
- Never compromise quality
- No incomplete logic
- Maximum code in single implementation
- Logical stopping points only
- 100% working final result
- No placeholders
- Full implementation required

### 13.2 Continuation Rules
- Continue from exact stopping line if interrupted
- Never rewrite previous code
- Maintain consistency across all modules

## 14. Reference Files

1. Uploaded Image: IMG_8566.png