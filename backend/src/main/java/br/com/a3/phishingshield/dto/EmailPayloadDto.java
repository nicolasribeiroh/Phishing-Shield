package br.com.a3.phishingshield.dto;

import java.util.ArrayList;
import java.util.List;

public class EmailPayloadDto {
    private String senderName;
    private String senderEmail;
    private String subject;
    private String bodyText;
    private List<LinkDto> links = new ArrayList<>();

    public EmailPayloadDto() {}

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }

    public String getSenderEmail() { return senderEmail; }
    public void setSenderEmail(String senderEmail) { this.senderEmail = senderEmail; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getBodyText() { return bodyText; }
    public void setBodyText(String bodyText) { this.bodyText = bodyText; }

    public List<LinkDto> getLinks() { return links; }
    public void setLinks(List<LinkDto> links) { this.links = links; }
}
