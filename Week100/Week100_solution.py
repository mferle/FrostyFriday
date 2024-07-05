# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
from io import BytesIO
import binascii  

st.title("Frosty Friday Week 100")

# Get the current credentials
session = get_active_session()

# Get data from the table
df = session.sql("select file_name, image_bytes from IMAGES").to_pandas()

# loop through the data frame
for ind in df.index:

    # construct the caption
    caption = 'Image from file ' + df['FILE_NAME'][ind]

    # get hex-encoded image bytes
    hex_string = df['IMAGE_BYTES'][ind]

    # convert to image stream
    byte_string = binascii.unhexlify(hex_string)  
    image_bytes = bytes(byte_string)
    image_stream = BytesIO(image_bytes)

    # display the image and caption
    st.image(image_stream, caption = caption)
