# Email Automation System - Technical Documentation

## Overview

This document explains the implementation of an intelligent email automation system using n8n, deployed via Docker. The system monitors incoming Gmail messages, classifies them using a hybrid AI + keyword detection approach, and sends contextually appropriate automated responses.

---

## Approach & Methodology

### Architecture Decision: Hybrid Classification

I chose a **hybrid approach** combining OpenAI GPT-3.5-turbo for intelligent classification with a keyword-based fallback system. This decision was made for several reasons:

1. **Accuracy**: AI classification handles variations in how people express their intent (e.g., "What's the damage?" for pricing inquiries)
2. **Reliability**: Keyword fallback ensures the system works even if the AI API is unavailable or returns unexpected results
3. **Cost-effectiveness**: GPT-3.5-turbo provides excellent classification at minimal cost (~$0.0015 per 1K tokens)

### Email Categories

The system classifies emails into four categories:

| Category | Keywords | Use Case |
|----------|----------|----------|
| **PRICING** | pricing, cost, fee, quote, rate, price | Sales inquiries about service costs |
| **PARTNERSHIP** | partnership, collaboration, partner | Business development opportunities |
| **SUPPORT** | support, help, issue, problem, error, bug | Customer support requests |
| **GENERAL** | (default) | All other inquiries |

---

## Workflow Design

### Node Structure

```
[Gmail Trigger] → [Extract Content] → [AI Classification]
                                            ↓
                                    [Validate Response]
                                      ↓           ↓
                                    [Yes]       [No]
                                      ↓           ↓
                            [Use AI Result]  [Keyword Fallback]
                                      ↓           ↓
                                    [Category Switch]
                                    /    |    |    \
                             Pricing Partner Support General
                                    \    |    |    /
                                    [Send Response]
                                          ↓
                                    [Mark as Read]
```

### Key Nodes Explained

1. **Gmail Trigger**: Polls for unread emails every minute
2. **Extract Content**: Normalizes email data (sender, subject, body)
3. **AI Classification**: Sends email to OpenAI for categorization
4. **Validation**: Checks if AI returned a valid category
5. **Keyword Switch**: Fallback classification using string matching
6. **Response Templates**: Four distinct professional responses
7. **Gmail Send**: Replies in the same thread
8. **Mark as Read**: Prevents reprocessing

---

## Key Decisions & Trade-offs

### Decision 1: Polling vs Webhook Trigger

**Chosen**: Polling (every minute)

**Rationale**:
- Webhooks require public URL/tunnel setup (ngrok)
- Polling is simpler for local development
- 1-minute delay is acceptable for this use case

**Trade-off**: Slight delay in response time vs. simplicity

### Decision 2: Single AI Call vs Multiple Classifications

**Chosen**: Single classification call

**Rationale**:
- Reduces API costs
- Faster response time
- Simple prompt design

**Trade-off**: Less granular analysis vs. cost efficiency

### Decision 3: Response in Thread vs New Email

**Chosen**: Reply in same thread

**Rationale**:
- Better user experience
- Maintains conversation context
- Standard email etiquette

---

## Assumptions

1. **Email Volume**: System designed for moderate volume (~100 emails/day). High volume would require rate limiting
2. **Language**: Primarily English emails. Non-English may default to GENERAL category
3. **Single Sender Domain**: One Gmail account monitors and responds
4. **No Attachments**: Current implementation doesn't process email attachments
5. **Business Hours**: No time-based routing implemented

---

## Limitations

1. **No Multi-language Support**: AI classification optimized for English
2. **No Sentiment Analysis**: Doesn't detect urgency or emotion
3. **Static Templates**: Responses don't adapt based on email specifics
4. **No Learning**: System doesn't improve from feedback
5. **Single Keyword Match**: Doesn't handle emails with multiple categories well

---

## Setup Instructions

### Prerequisites

- Docker and Docker Compose installed
- Gmail account with API access
- OpenAI API key

### Step 1: Start n8n

```bash
cd "AI Frontend Developer Test"
docker compose up -d
```

Access n8n at: http://localhost:5678

### Step 2: Configure Gmail OAuth

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create project and enable Gmail API
3. Create OAuth 2.0 credentials (Web application)
4. Add redirect URI: `http://localhost:5678/rest/oauth2-credential/callback`
5. In n8n: Settings → Credentials → Add Gmail OAuth2

### Step 3: Configure OpenAI

1. Get API key from [OpenAI Platform](https://platform.openai.com/)
2. In n8n: Settings → Credentials → Add OpenAI API

### Step 4: Import Workflow

1. In n8n, click Import → From File
2. Select `email-workflow.json`
3. Update credentials in each node
4. Activate workflow

### Step 5: Test

Send test emails from a different account:
- "What are your prices?" → Should get pricing response
- "Let's partner up" → Should get partnership response
- "I need help" → Should get support response
- "Hello there" → Should get general response

---

## Future Improvements

1. **Multi-language Support**: Add language detection and localized responses
2. **Sentiment Analysis**: Prioritize urgent/angry emails
3. **Dynamic Templates**: Use AI to personalize responses
4. **Analytics Dashboard**: Track classification accuracy and response rates
5. **Escalation Rules**: Route complex queries to human agents

---

## Technologies Used

- **n8n**: Workflow automation platform
- **Docker**: Containerization
- **Gmail API**: Email monitoring and sending
- **OpenAI GPT-3.5-turbo**: Intelligent email classification

---

## Contact

For questions about this implementation, please contact the developer.

---

*Document Version: 1.0*
*Last Updated: December 9, 2025*
