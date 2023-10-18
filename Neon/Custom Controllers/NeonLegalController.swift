//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 18.10.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
open class NeonLegalController: UIViewController {

    
    private var appName : String{
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
          return "\(appName) App"
        } else {
            return "App"
        }
    }
    private var legalText = ""
    
    public enum LegalControllerType{
        case privacyPolicy
        case termsOfUse
    }
    var controllerType = LegalControllerType.termsOfUse
    var titleColor = UIColor()
    var backgroundColor = UIColor()
    var headerColor = UIColor()
    var legalTextColor = UIColor()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // Header View
        
        view.backgroundColor = backgroundColor
        let headerView = UIView()
        headerView.backgroundColor = headerColor
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        
        
        
        let titleLabel = UILabel()
        titleLabel.text =  controllerType == .termsOfUse ? "Terms of Use" : "Privacy Policy"
        titleLabel.textColor = titleColor
        titleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        // Back Button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = titleColor
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        headerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(50)
        }

        setLegalText(isTerms: controllerType == .termsOfUse)
        let termsTextView = UITextView()
        termsTextView.isEditable = false
        termsTextView.contentOffset = CGPoint(x: 0, y: 0)
        termsTextView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        termsTextView.text = legalText
        termsTextView.font = Font.custom(size: 14, fontWeight: .Medium) // You can customize the font
        termsTextView.backgroundColor = .clear
        termsTextView.textColor = legalTextColor
        view.sendSubviewToBack(termsTextView)
        view.addSubview(termsTextView)
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    
    func setLegalText(isTerms : Bool){
        
        if isTerms{
             legalText = """
                
                I. INTRODUCTION
                
                These Terms of Use and End User License Agreement (collectively, the “Agreement”) together with all the documents referred to in it constitute a legally binding agreement made between you as a natural person (“you”, “your” or “user”) and \(appName) (“we,” “us” or “our”), concerning your access to and use of \(appName) for mobile devices (the “App”). The App’s title may vary in countries other than the U.S. and is subject to change without specific notice.
                
                All the documents that relate to the App are hereby expressly incorporated herein by reference.
                Please read this Agreement carefully before you download, install or use the App.
                It is important that you read and understand this Agreement as by downloading, installing or using the App you indicate that you have read, understood, agreed and accepted the Agreement which takes effect on the date on which you download, install or use the App. By using the App you agree to abide by this Agreement.
                
                If you do not agree with (do not accept) this Agreement, or if you do not agree at least with one of the provisions of this Agreement, you are not authorized to, and you may not access, download, install or use the App and you must promptly discontinue downloading, installing the App and remove (delete) the App from any mobile device in your possession or under your control.
                
                II. CHANGES TO THIS AGREEMENT
                
                We reserve the right, at our sole discretion, to make changes or modifications to this Agreement at any time and for any reason. We will keep you informed about any changes by updating this Agreement and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review this Agreement to stay informed of updates. You will be subject to, and will be deemed to be aware of and to have accepted, the changes in any revised Agreement by your continued use of the App after the date such revised Agreement is posted.
                
                III. RESTRICTIONS ON WHO CAN USE THE APP
                
                In order to download, install, access or use the App, you must (a) be eighteen (18) years of age or older.
                
                All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the App, so if you are between the ages of thirteen (13) and seventeen (17) years and you wish to use, download, install, access the App, before doing so you must: (a) assure and confirm (if needed) that your parent or guardian have read and agree (get your parent or guardian’s consent) to this Agreement prior to you using the App; (b) have the power to enter a binding contract with us and not be barred from doing so under any applicable laws.
                
                Parents and guardians must directly supervise any use of the App by minors.
                Any person under the age of thirteen (13) years is not permitted to download, install, access or use the App.
                
                You affirm that you are either more than eighteen 18 years of age, or an emancipated minor, or possess legal parental or guardian consent, and are fully able and competent to enter into the terms, conditions, obligations, affirmations, representations, and warranties set forth in this Agreement, and to abide by and comply with this Agreement.
                
                IV. GENERAL TERMS
                
                The App is a utility program designed to enhance your device experience. The App furnishes dynamic videos and themes ready to install on your device, along with keyboards, lock screens and other related features.
                
                The App is intended only for your personal non-commercial use. You shall use the App only for the purposes, mentioned above.
                
                V. PRIVACY POLICY
                
                Your privacy is very important to us. Accordingly, we have developed the Privacy Policy in order for you to understand how we process, use and store information including personal data. Access to the App and use of the Services are subject to the Privacy Policy. By accessing the App and by continuing to use the Services, you are deemed to have accepted the Privacy Policy, and in particular, you are deemed to have acknowledged the ways we process your information as well as appropriate legal grounds for processing described in the Privacy Policy. We reserve the right to amend the Privacy Policy from time to time. If you disagree with any part of the Privacy Policy, you must immediately stop using the App and Services. Please read our Privacy Policy carefully.
                
                VI. END USER LICENSE AGREEMENT
                
                By using the App, you undertake to respect our intellectual rights (intellectual rights related to the App’s source code, UI/UX design, content material, copyright and trademarks, hereinafter referred to as the “Intellectual Property Rights”) as well as those owned by third parties.
                
                As long as you keep using the App, we grant you a limited, non-exclusive, non-transferable non-sublicensable, non-assignable and revocable right to access and use the App pursuant to this Agreement (the “License”).
                
                The source code, design and content, including information, photographs, illustrations, artwork and other graphic materials, sounds, music or video (hereinafter – the “works”) as well as names, logos and trademarks (hereinafter – “means of individualization”) within the App are protected by copyright laws and other relevant laws and/or international treaties, and belong to us and/or our partners and/or contracted third parties, as the case may be.
                
                These works and means of individualization may not be copied, reproduced, retransmitted, distributed, disseminated, sold, published, broadcasted or circulated whether in whole or in part, unless expressly permitted by us and/or our partners and/or contracted third parties, as the case may be.
                
                All rights, title and interest in and to the App and its content, works and means of individualization as well as its functionalities (1) are the exclusive property of Live Wallpapers and/or our partners and/or contracted third parties, (2) are protected by the applicable international and national legal provisions, and (3) are under no circumstances transferred (assigned) to you in full or in part within the context of the license herewithin.
                
                We will not hesitate to take legal action against any unauthorized use of our trademarks, names or symbols to protect and restore our rights. All rights not expressly granted herein are reserved. Other product and company names mentioned herein may also be the trademarks of their respective owners.
                
                VII. PROHIBITED BEHAVIOUR
                
                You agree not to use the App in any way that:
                
                • - is unlawful, illegal or unauthorized;
                • - is defamatory of any other person;
                • - is obscene or offensive;
                • - infringes any copyright, database right or trademark of any other person;
                • - advocates, promotes or assists any unlawful act such as (by way of example only) copyright infringement or computer misuse.
                
                You shall not make the App available to any third parties. In addition, you shall not modify, translate into other languages, reverse engineer, decompile, disassemble or otherwise create derivative works from the App or any documentation concerning the App.
                
                You shall not transfer, lend, rent, lease, distribute the App, or use it for providing services to a third party, or grant any rights to the App or any documentation concerning the App to a third party.
                
                Misuse of any trademarks or any other content displayed on the App is prohibited.
                
                You shall not copy and/or duplicate and/or distribute and/or publish and/or use any content in the App, directly or indirectly, by way of a violation of our Intellectual Property Rights.
                
                Moreover, you shall not make any attempts to use the App or part thereof for malicious intentions.
                Also we are not responsible for the way you use the App.
                
                It is clarified that we may adopt, against a user who violated the present Agreement, any legal measures at our disposal pursuant to the applicable laws.
                
                All disputed arising from the usage of the App, shall be governed by and construed in accordance with the laws of the United States of America, and shall be submitted to the sole jurisdiction of the competent courts of New York, the United States of America.
                
                VIII. AVAILABILITY OF THE APP, SECURITY AND ACCURACY
                
                In order to use the App, you are required to have a compatible mobile phone or tablet, and internet access.
                
                The App is available for downloading and installing on handheld compatible mobile devices running Apple iOS Operating System 10.0 or later.
                
                We do not warrant that the App will be compatible with all hardware and software which you may use.
                We make no warranty that your access to the App will be uninterrupted, timely or error-free.
                
                You acknowledge the App is provided via the internet and mobile networks and so the quality and availability of the App may be affected by factors outside our reasonable control.
                
                The version of the App may be upgraded from time to time to add support for new functions and services.
                
                We may change or update the App and anything described in it without noticing you. If the need arises, we may suspend access to the App, or close it indefinitely.
                
                You also warrant that any information that you submit to us is true, accurate and complete, and you agree to keep it actual at all times.
                
                You can discontinue using our Services at any time by choosing the relevant option in your iTunes Account Settings. If you decide not to use the App for any reason you should uninstall the App.
                
                IX. CHARGES
                
                The App is provided on free basis. Once you download the App, you’ll have access to its basic features.
                
                Access to some services and/or additional features within the App requires paid subscriptions. The full list of Premium options and pricing is provided on the App’s page. You will have an opportunity to try Premium options during the free trial period as provided on the signup screen. After the free trial period expires an auto-renewing subscription period will start on a regular basis. Please mind that you will be charged automatically unless you cancel your subscription 24 hours before the end of the free trial period. When you cancel your subscription you will still have access to basic functions of the App. Premium options are available during the whole free trial period.
                
                You can choose different subscription options. Current subscription price starts at $9.99/week. Prices are in U.S. dollars and may vary in countries other than the U.S. You will have all necessary information about your subscription plan and duration of the free trial period on the signup screen before the purchase.
                
                Subscription with a free trial period will automatically renew to a paid subscription. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription, where applicable. We reserve the right to modify, terminate or otherwise amend our offered subscription plans at any time.
                
                Your subscription will be automatically renewed within 24 hours before the current subscription ends. Auto-renew option can be turned off in your iTunes Account Settings at least 24 hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. No cancellation of the current subscription is allowed during active subscription period. Subscriptions are managed by you. Please note that removing the App from your device does not deactivate your subscription.
                
                Certain services within the App may be available as an In-App Purchase.
                
                You may be charged by your communications service provider for downloading and/or accessing the App on your mobile phone or tablet device, so you should check the terms of agreement with your operator. This may include data roaming charges if you do this outside your home territory. All these charges are solely your responsibility. If you do not pay the bills related to your mobile phone or tablet device, then we assume that you have the permission from the person that does it before incurring any of these charges.
                
                X. THIRD PARTY WEBSITES AND RESOURCES
                
                The App may link you to other sites on the Internet and contracted third parties to provide you certain services. We have no control over and accept no responsibility for the content of any website or mobile application to which a link from the App exists (unless we are the provider of those linked websites or mobile applications). Such linked websites and mobile applications are provided “as is” for your convenience only with no warranty, express or implied, for the information provided within them.
                
                You acknowledge sole responsibility for and assume all risk arising from, your use of any third-party websites or resources.
                
                If you have any queries, concerns or complaints about such third party websites or mobile applications (including, but not limited to, queries, concerns or complaints relating to products, orders for products, faulty products and refunds) you must direct them to the operator of that third party website or mobile application.
                
                XI. DISCLAIMER OF WARRANTIES
                
                YOU AGREE THAT YOUR USE OF THE APP AND ITS SERVICES SHALL BE AT YOUR SOLE RISK. THE SERVICES AND ALL THE MATERIALS, INFORMATION, SOFTWARE, CONTENT INTEGRATEYOU AGREE THAT YOUR USE OF THE APP AND ITS SERVICES SHALL BE AT YOUR SOLE RISK. THE SERVICES AND ALL THE MATERIALS, INFORMATION, SOFTWARE, CONTENT INTEGRATED IN THE APP ARE PROVIDED “AS IS” AND “AS AVAILABLE”. WE DO NOT MAKE ANY WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, WITH REGARD TO THE MERCHANTABILITY, TECHNICAL COMPATIBILITY OR FITNESS FOR A PARTICULAR PURPOSE OF ANY SERVICE, PRODUCTS OR MATERIAL PROVIDED PURSUANT TO THIS AGREEMENT. WE DO NOT WARRANT THAT THE FUNCTIONS CONTAINED ON OR THROUGH THE SERVICES WILL BE AVAILABLE, UNINTERRUPTED OR ERROR-FREE, THAT DEFECTS WILL BE CORRECTED, OR THAT THE SERVICES OR THE SERVERS THAT MAKE THE SERVICE AVAILABLE ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS.
                
                We do not give you any guarantee for the proper functionality of the App, however, if you believe that our App has not met your expectations, you may notify Apple, and Apple may refund the purchase price for the App to you; and that, to the maximum extent permitted by applicable law, Apple will have no other warranty obligation whatsoever with respect to the App, and any other claims, losses, liabilities, damages, costs or expenses attributable to any failure to conform to any warranty.
                
                XII. LIMITATION OF LIABILITY
                
                IN NO EVENT SHALL WE BE LIABLE FOR DAMAGES OF ANY TYPE, WHETHER DIRECT OR INDIRECT, ARISING OUT OF OR IN ANY WAY RELATED TO THE APP AND SERVICES PROVIDED BY THE APP. WE SHALL NOT BE LIABLE UNDER ANY CIRCUMSTANCES FOR ANY SPECIAL, CONSEQUENTIAL, INCIDENTAL, EXEMPLARY OR PUNITIVE DAMAGES, OR LOSS OF PROFIT OR REVENUES, EVEN IF WE HAVE BEEN SPECIFICALLY ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. WE SHALL NOT BE LIABLE UNDER ANY CIRCUMSTANCES FOR DAMAGES ARISING OUT OF OR IN ANY WAY RELATED TO PRODUCTS, SERVICES AND/OR INFORMATION OFFERED OR PROVIDED BY ANY THIRD-PARTIES AND ACCESSED THROUGH THE APP OR BY ANY OTHER MEANS. YOU ALSO SPECIFICALLY ACKNOWLEDGE THAT WE ARE NOT LIABLE FOR COSTS OR DAMAGES ARISING OUT OF PRIVATE OR GOVERNMENTAL LEGAL ACTIONS RELATED TO YOUR USE OF ANY OF THE APP AND ITS SERVICES IN ANY COUNTRY.
                
                Apple is not responsible for addressing your claims relating to the App or your possession and/or use of the App, including, but not limited to: (i) product liability claims; (ii) any claim that the App fails to conform to any applicable legal or regulatory requirement; and (iii) claims arising under consumer protection, privacy, or similar legislation.
                
                XIII. LEGAL COMPLIANCE
                
                You must represent and warrant that (i) you are not located in a country that is subject to a U.S. Government embargo, or that has been designated by the U.S. Government as a “terrorist supporting” country; and (ii) you are not listed on any U.S. Government list of prohibited or restricted parties.
                
                XIV. THIRD PARTY BENEFICIARY
                
                You acknowledge and agree that Apple, and Apple’s subsidiaries are the third party beneficiaries of the present end-user license agreement, and that upon your acceptance of the terms and conditions of the present Terms of Use and EULA, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms of Use and EULA as a third party beneficiary thereof.
                
                XV. GOVERNING LAW AND CLAIMS
                
                This Agreement shall be governed by and construed in accordance with the laws of the State of New York.
                
                We make no representations that the App is appropriate or available for use in other locations. Those who access or use the App from other jurisdictions do so at their own volition and are responsible for compliance with local law.
                
                If you choose to access or use the App from or in locations outside of the United States, you are responsible for:
                a) ensuring that what you are doing in that country is legal; and
                b) the consequences and compliance by you with all applicable laws, regulations, bylaws, codes of practice, licenses, registrations, permits and authorizations.
                
                Any claims shall be exclusively decided by courts of competent jurisdiction in New York, New York and that applicable Federal law shall govern, without regard to choice of law principles.
                
                If you ever wish to seek any relief from us, you agree to waive the ability to pursue class action.
                If any controversy, allegation, or claim (including any non-contractual claim) arises out of or relates to the App and the Services provided by the App or this Agreement, then you and we agree to send a written notice to each other providing a reasonable description of the dispute, along with a proposed resolution of it. The notice shall be sent based on the most recent contact information. For a period of sixty (60) days from the date of receipt of notice from the other party, you and us will engage in a dialogue in order to attempt to resolve the dispute, though nothing will require either you or us to resolve the dispute on terms which either you or us, in each of our sole discretion, are uncomfortable with.
                
                XVI. TERMINATION
                
                We reserve the right to terminate this Agreement at any time at our sole discretion for any reason.
                Upon any termination, (a) the rights and licenses granted to you herein shall terminate; (b) you must cease all use of the App.
                
                XVII. SEVERABILITY
                
                If at any time any provision of this Agreement is or becomes illegal, invalid or unenforceable in any respect, that provision shall be read down to become illegal, invalid or unenforceable or, if this is not possible, deleted. The other terms of this Agreement shall continue to apply with full force and effect.
                
                You shall not assign or transfer or purport to assign or transfer the contract between you and us to any other person.
                """
        }else{
            legalText =
            """
            
            I. INTRODUCTION

            \(appName) ("we," "us" or "our") takes your privacy seriously. This Privacy Policy explains our data protection policy and describes the types of information we may process when you install and/or use the \(appName) software application for mobile devices (the "App").

            When we refer to personal data (or personal information), we mean any information of any kind relating to a natural person who can be identified, directly or indirectly, in particular by reference to such data.

            A natural person can be identified directly or indirectly, especially by reference to an identification number or one or more factors specific to their physical, physiological, mental, economic, cultural, or social status.

            Our Privacy Policy applies to all users and others who access the App ("Users").

            For the purposes of the GDPR, we are the data controller unless otherwise stated.

            Please read the following Privacy Policy carefully to understand how your personal information may be processed when you use the App. By using the App, you acknowledge that you have read, understood, and agree to be bound by these terms.

            If you are a California resident, please read the following important notice.

            Under the California Consumer Privacy Act of 2018 (CCPA), California residents have the right to request:

            The categories of personal information that are processed.
            The categories of sources from which personal information is obtained.
            The purpose for processing user personal data.
            The categories of third parties with whom we may share your personal information.
            The specific pieces of personal information that we might have obtained about a particular user, provided that the data given in the request is reliable enough and allows us to identify the user.
            Please use the navigation links through this Privacy Policy:

            I. PERSONAL INFORMATION

            All about the categories of information, its sources, and purposes of processing.

            Please note that according to CCPA, personal information does not include de-identified or aggregated consumer information.

            II. SHARING

            How your information can be shared.

            Please note that all third parties that are engaged in processing user data are service providers that use such information on the basis of an agreement and pursuant to a business purpose.

            III. OPT-OUT OPTIONS

            If you don’t want us to process your personal information anymore, please contact us through the contact us section of the app. In most cases, there is no way to maintain the App’s further operation without functional data; therefore, you will be advised to remove the App from your device.

            If you don’t want us to share device identifiers and geolocation data with service providers, please check your device settings to opt out as described below.

            IV. REQUESTS

            To submit a verifiable consumer request for access, portability, or deletion of personal data, please contact us through the contact us section of the app. Please include in the text of your appeal the wording "Your rights to maintain confidentiality in the state of California.” When submitting a verifiable request, you should be ready to:

            Provide sufficient information that allows us to reasonably verify you are the person about whom we collected personal information or an authorized representative, which may include: name, address, city, state, zip code, and email address. We may use this information to surface a series of security questions to verify your identity. If you are making a request through an authorized agent acting on your behalf, such authorized agent must provide written authorization confirming or a power of attorney, signed by you.
            Describe your request with sufficient detail that allows us to properly understand, evaluate, and respond to it.
            We will not be able to respond to your request or provide you with personal information if we cannot: (i) verify your identity or authority to make the request; or (ii) confirm the personal information relates to you. We may ask you for additional information or documents to verify your identity. We may also carry out checks, including with third-party identity verification services, to verify your identity before taking any action with your personal information. This is regarded as a safeguard measure to prevent disclosure of your personal information under a fake or scam request.

            We ensure that personal information provided in a verifiable consumer request will be used only to verify the requestor’s identity or authority to make the request and not for any other purpose. We will keep it for the adequate term reasonably needed for the purpose described above and delete it after the purpose is fulfilled.

            We try to respond to a verifiable consumer request within forty-five (45) days of its receipt. If we require more time, we will inform you of the reason and extension period in writing. Please note that we are only required to respond to two requests per customer each year.

            V. EQUAL RIGHTS

            Nothing in the way we deal with your request shall be interpreted as discrimination, which means that we will not set up different pricing or products, or different levels or quality of services for you if you choose to exercise your rights. However, in some circumstances, we may not be able to provide services if you choose to delete your personal information from our records.

            VI. SALE OF DATA

            We do not sell any of your personal data to third parties.

            VII. INFORMATION WE PROCESS

            There are several categories of information that can be processed.

            Functional Information

            We process the following personal information about you when you use the App. This information is necessary for the adequate performance of the contract between you and us. Without such information, it is impossible to provide complete functionality of the App and perform the requested services. What data can be processed:

            Content Information, i.e., photos, pictures, and other data - when you upload or create them using the App.
            Contact Information (name, e-mail address, as well as any other content included in the email) which you may fill in by yourself when you contact us via email, support form. We collect, store, and process it by our cloud storage provider (Amazon.com, Inc.). We use such information to respond effectively to your inquiry, fulfill your requests, and send you communications that you request.
            Information That Is Processed Automatically

            When you use the App, some information about your device and your user behavior may be processed automatically. This information is generally non-personal, i.e., it does not, on its own, permit direct association with any specific individual, and we may access it only in aggregated form. We process this information on the grounds of our legitimate interest in improving our App and giving our users the best experience. If we do not access such data, we may not be able to provide you with all the features of the App.

            We use third-party automatic data processing technologies to analyze certain information sent by your device via our App (advertising or analytics tools). Some of them launch automated processing of your personal data, including profiling, which means any form of automated processing of personal data used to evaluate certain personal aspects relating to you, in particular to analyze or predict aspects concerning your personal preferences, interests, behavior, location, or movements (see the list of data described below). Processing information through automatic data processing technologies starts automatically when you first launch the App.

            Device Details

            When you use a mobile device (tablet / phone / smartwatch) to access our App, some details about your device are reported, including “device identifiers”. Device identifiers are small data files or similar data structures stored on or associated with your mobile device, which uniquely identify your mobile device (but not your personality). Device identifier enables generalized reporting or personalized content and ads by the third parties.

            What data can be processed:

            Information about the device itself: type of your device, type of operating system and its version, model and manufacturer, screen size, screen density, orientation, audio volume, and battery, device memory usage.
            Information about the internet connection: mobile carrier, network provider, network type, IP address, timestamp, and duration of sessions, speed, browser.
            Location-related information: IP address, the country code/ region/ state/ city associated with your SIM card or your device, language setting, time zone, neighboring commercial points of interest (eg. “coffee shop”).
            Device identifiers: Identity For Advertisers for iOS devices/ Advertising ID or Android ID for Android devices, user identifiers (if they are set up by the App’s developer).
            Information about the applications. Name, API key (identifier for application), version, properties of our App can be reported for automated processing and analyzes. Some services also record the list of applications and/or processes that are installed or run on your device.
            Cookies and similar technologies. When you use the App, cookies and similar technologies may be used (pixels, web beacons, scripts). A cookie is a text file containing small amounts of information which is downloaded to your device when you access the App. The text file is then sent back to the server each time you use the App. This enables us to operate the App more effectively. For example, we will know how many users access specific areas or features within our App and which links or ads they clicked on. We use this aggregated information to understand and optimize how our App is used, improve our marketing efforts, and provide content and features that are of interest to you. We may ask advertisers or other partners to serve ads or services to the App, which may use cookies or similar technologies.
            Log file information. Log file information is automatically reported each time you make a request to access the App. It can also be provided when the App is installed on your device. When you use our App, analytics tools automatically record certain log file information, including the time and date when you start and stop using the App and how you interact with the App.
            Ad-related information. The following data might be reported about the ads you can view: the date and time a particular ad is served; a record if that ad was “clicked” or if it was shown as a “conversion” event; what the ad offer is about; what type of ad it is (e.g., text, image, or video); which ad placement is involved (where the ad offer is displayed within the App); whether you respond to the ad.
            In-app events. When you use our App, analytics tools automatically record your activity information (tutorial steps, leveling up, payments, in-app purchases, custom events, progression events, method of limiting the processing of user data).
            Information provided automatically to advertising or analytics tools does not generally come under our control; therefore, we cannot be responsible for processing such information. Please note that some services are engaged in personal data profiling and may obtain information related to your personality and/or your device by using technologies that do not belong to our scope of responsibility. In case when your user ID is linked to your Facebook account, Facebook may use your device information in association with categorized data that were already recorded in its databases (eg. your age, gender or other demographic indication). We do not control, supervise, or stand surety for how the third parties process your personal data, that might be collected by their own means (not through our App). Any information request regarding the disclosure of your personal information should be directed to such third parties.

            VIII. PAYMENT INFORMATION

            Our e-commerce provider (Apple / Google) is responsible for billing, processing, and charging for the in-app purchases, handles your personal information, and keeps it absolutely safe and secure. We cannot access or use your credit or debit card information. You may access the applicable “in-app” purchase rules and policies directly from the app stores.

            IX. THE PURPOSES OF PROCESSING YOUR PERSONAL DATA

            Our mission is to constantly improve our App and provide you with new experiences. As part of this mission, we use your information for the following purposes:

            (a) To make our service available. We use the functional information and information that is processed automatically to provide you with all requested services.

            (b) To improve, test, and monitor the effectiveness of our App. We use the information that is processed automatically to better understand user behavior and trends, detect potential outages and technical issues, to operate, protect, improve, and optimize our App.

            (c) To provide you with interest-based (behavioral) advertising or other targeted content. We may use information that is processed automatically for marketing purposes (to show ads that may be of interest to you based on your preferences). We provide personalized content and information to you, which can include online ads or other forms of marketing.

            (d) To communicate with you. We use the information we have to communicate with you through newsletters, i.e., to send you marketing notifications, receive your feedback about our App experience, and let you know about our policies and terms. We also use your information to respond to you when you contact us.

            (e) To prevent fraud and spam, to enforce the law. We really want our App to be free of spam and fraudulent content so that you feel safe and free. We may use your information to prevent, detect, and investigate fraud, security breaches, potentially prohibited or illegal activities, protect our trademarks, and enforce our Terms of Use.

            If any new purposes for processing your personal data arise, we will let you know we start to process information for that other purpose by introducing the corresponding changes to this Privacy Policy.

            X. SHARING OF YOUR INFORMATION

            We will share your information with third parties only in the ways that are described in this Privacy
            """
        }
        
        
    }
    
}



