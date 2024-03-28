package fr.bluewhale.session;

import java.util.*;
import java.io.*;
import javax.mail.*;
import javax.mail.internet.*;

public class SystemMail {

	public int Send(String strFrom, String strTo, String strTopic, String strSmtp, String strUser, String strPasswd, String strBody)
	{
		// Recipient's email ID needs to be mentioned.
		String to = strTo;

		//Sender's email ID needs to be mentioned
		String from = strFrom;

		// Get system properties
		Properties properties = System.getProperties();
		// Setup mail server
		properties.setProperty("mail.smtp.host", strSmtp);
		properties.setProperty("mail.transport.protocol", "smtp");
		if( strUser == null && strPasswd == null )properties.put("mail.smtp.auth","false");
		else                                      properties.put("mail.smtp.auth","true");
		if( strUser   != null ) properties.setProperty("mail.user", strUser);
		if( strPasswd != null ) properties.setProperty("mail.password", strPasswd);

		// Get the default Session object.
		Session session = Session.getDefaultInstance(properties);

		try
		{
			// Create a default MimeMessage object.
			MimeMessage message = new MimeMessage(session);

			message.setFrom(new InternetAddress(from));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
			message.setSentDate(new Date());
			message.setSubject(strTopic);

			// Now set the actual message
			String strContent = strBody;
			String strTypeMime = "text/html";
			
			message.setContent(strContent,	strTypeMime);

			// Send message
			Transport transport = session.getTransport();
			transport.connect(strSmtp,strUser,strPasswd);
			transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
			transport.close();
		 	//Transport.send(message);
	         //System.out.println("Sent message successfully....");
			return 1;
		}
		catch (MessagingException mex)
		{
	         mex.printStackTrace();
	         return 0;
		}
	}
}
