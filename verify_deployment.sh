#!/bin/bash

# Quick Verification Script for dineo.digitalflux.co.za
# Run this from your local machine to verify the deployment

DOMAIN="dineo.digitalflux.co.za"

echo "========================================="
echo "Verifying Deployment: $DOMAIN"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check DNS Resolution
echo -n "DNS Resolution: "
IP=$(dig +short $DOMAIN | head -n1)
if [ -n "$IP" ]; then
    echo -e "${GREEN}✓ $DOMAIN → $IP${NC}"
else
    echo -e "${RED}✗ Failed to resolve${NC}"
    exit 1
fi

# Check HTTP
echo -n "HTTP (port 80): "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 http://$DOMAIN/)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
    echo -e "${GREEN}✓ $HTTP_CODE${NC}"
else
    echo -e "${RED}✗ $HTTP_CODE${NC}"
fi

# Check HTTPS
echo -n "HTTPS (port 443): "
HTTPS_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://$DOMAIN/)
if [ "$HTTPS_CODE" = "200" ] || [ "$HTTPS_CODE" = "301" ] || [ "$HTTPS_CODE" = "302" ]; then
    echo -e "${GREEN}✓ $HTTPS_CODE${NC}"
else
    echo -e "${RED}✗ $HTTPS_CODE${NC}"
fi

# Check SSL Certificate
echo -n "SSL Certificate: "
CERT_INFO=$(echo | openssl s_client -connect $DOMAIN:443 -servername $DOMAIN 2>/dev/null | openssl x509 -noout -subject -dates 2>/dev/null)
if [ $? -eq 0 ]; then
    CERT_SUBJECT=$(echo "$CERT_INFO" | grep "subject=" | cut -d= -f2-)
    CERT_EXPIRY=$(echo "$CERT_INFO" | grep "notAfter=" | cut -d= -f2)
    echo -e "${GREEN}✓ Valid until $CERT_EXPIRY${NC}"
    echo "  Subject: $CERT_SUBJECT"
else
    echo -e "${RED}✗ Invalid or expired${NC}"
fi

# Check SSL Grade (requires curl)
echo -n "SSL Configuration: "
SSL_TEST=$(curl -s "https://api.ssllabs.com/api/v3/analyze?host=$DOMAIN&publish=off&fromCache=on" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Tested (check https://www.ssllabs.com/ssltest/analyze.html?d=$DOMAIN)${NC}"
else
    echo -e "${YELLOW}⚠ Manual check recommended${NC}"
fi

# Check HTTP to HTTPS Redirect
echo -n "HTTP → HTTPS Redirect: "
REDIRECT=$(curl -s -o /dev/null -w "%{redirect_url}" --max-time 10 -L http://$DOMAIN/ | grep -q "https://" && echo "yes" || echo "no")
if [ "$REDIRECT" = "yes" ]; then
    echo -e "${GREEN}✓ Redirecting${NC}"
else
    echo -e "${YELLOW}⚠ Not redirecting (may be intentional)${NC}"
fi

# Check Response Time
echo -n "Response Time: "
RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" --max-time 10 https://$DOMAIN/)
if (( $(echo "$RESPONSE_TIME < 2.0" | bc -l) )); then
    echo -e "${GREEN}✓ ${RESPONSE_TIME}s${NC}"
elif (( $(echo "$RESPONSE_TIME < 5.0" | bc -l) )); then
    echo -e "${YELLOW}⚠ ${RESPONSE_TIME}s (acceptable)${NC}"
else
    echo -e "${RED}✗ ${RESPONSE_TIME}s (slow)${NC}"
fi

# Check Security Headers
echo -n "Security Headers: "
HEADERS=$(curl -s -I --max-time 10 https://$DOMAIN/ | grep -i "strict-transport-security\|x-frame-options\|x-content-type-options")
if [ -n "$HEADERS" ]; then
    echo -e "${GREEN}✓ Present${NC}"
else
    echo -e "${YELLOW}⚠ Some headers missing${NC}"
fi

# Test actual content
echo -n "Content Accessibility: "
CONTENT=$(curl -s --max-time 10 https://$DOMAIN/ | head -c 100)
if [ -n "$CONTENT" ]; then
    echo -e "${GREEN}✓ Content received${NC}"
    echo "  Preview: ${CONTENT:0:50}..."
else
    echo -e "${RED}✗ No content${NC}"
fi

echo ""
echo "========================================="
echo "Verification Complete"
echo "========================================="
echo ""
echo "For detailed SSL analysis:"
echo "https://www.ssllabs.com/ssltest/analyze.html?d=$DOMAIN"
echo ""
echo "For DNS propagation check:"
echo "https://www.whatsmydns.net/#A/$DOMAIN"

