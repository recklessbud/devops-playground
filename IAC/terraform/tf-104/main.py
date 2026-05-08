# this the code for for lambda color pallete# Create the Lambda function code
import json
import random
import colorsys
import boto3
import os
from datetime import datetime
import uuid

# Initialize S3 client
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # Get bucket name from environment variable
    bucket_name = os.environ.get('BUCKET_NAME')
    if not bucket_name:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': 'Bucket name not configured'})
        }
    
    try:
        # Generate color palette based on requested type
        query_params = event.get('queryStringParameters') or {}
        palette_type = query_params.get('type', 'complementary')
        palette = generate_color_palette(palette_type)
        
        # Store palette in S3
        palette_id = str(uuid.uuid4())[:8]
        s3_key = f"palettes/{palette_id}.json"
        
        palette_data = {
            'id': palette_id,
            'type': palette_type,
            'colors': palette,
            'created_at': datetime.utcnow().isoformat(),
            'hex_colors': [rgb_to_hex(color) for color in palette]
        }
        
        s3_client.put_object(
            Bucket=bucket_name,
            Key=s3_key,
            Body=json.dumps(palette_data, indent=2),
            ContentType='application/json'
        )
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type'
            },
            'body': json.dumps(palette_data)
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': str(e)})
        }

def generate_color_palette(palette_type):
    """Generate color palette based on color theory"""
    base_hue = random.uniform(0, 1)
    saturation = random.uniform(0.6, 0.9)
    lightness = random.uniform(0.4, 0.8)
    
    colors = []
    
    if palette_type == 'complementary':
        # Base color and its complement
        colors.append(hsv_to_rgb(base_hue, saturation, lightness))
        colors.append(hsv_to_rgb((base_hue + 0.5) % 1, saturation, lightness))
        colors.append(hsv_to_rgb(base_hue, saturation * 0.7, lightness * 1.2))
        colors.append(hsv_to_rgb((base_hue + 0.5) % 1, saturation * 0.7, lightness * 1.2))
        
    elif palette_type == 'analogous':
        # Colors adjacent on color wheel
        for i in range(5):
            hue = (base_hue + (i * 0.08)) % 1
            colors.append(hsv_to_rgb(hue, saturation, lightness))
            
    elif palette_type == 'triadic':
        # Three colors evenly spaced on color wheel
        for i in range(3):
            hue = (base_hue + (i * 0.333)) % 1
            colors.append(hsv_to_rgb(hue, saturation, lightness))
        # Add two supporting colors
        colors.append(hsv_to_rgb(base_hue, saturation * 0.5, min(lightness * 1.3, 1.0)))
        colors.append(hsv_to_rgb(base_hue, saturation * 0.3, lightness * 0.9))
        
    else:  # Random palette
        for i in range(5):
            hue = random.uniform(0, 1)
            sat = random.uniform(0.5, 0.9)
            light = random.uniform(0.3, 0.8)
            colors.append(hsv_to_rgb(hue, sat, light))
    
    return colors

def hsv_to_rgb(h, s, v):
    """Convert HSV color to RGB"""
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    return [int(r * 255), int(g * 255), int(b * 255)]

def rgb_to_hex(rgb):
    """Convert RGB to hex color code"""
    return f"#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}"
