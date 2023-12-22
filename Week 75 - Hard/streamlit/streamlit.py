import streamlit as st
from snowflake.snowpark.context import get_active_session
import snowflake.permissions as permissions
from sys import exit

st.set_page_config(layout="wide")
session = get_active_session()

if hasattr(st.session_state, "permission_granted"):
    pass
else:
    # If not, trigger the table referencing process
    permissions.request_reference("consumer_table")
    # And add a variable in the session to mark that this is done
    st.session_state.permission_granted = True

if not permissions.get_held_account_privileges(["CREATE DATABASE"]): # check for database permission
    # otherwise, request it
    permissions.request_account_privileges(["CREATE DATABASE"])
    st.session_state.privilege_granted = True

st.title("FrostyPermissions!")

check = st.button('Shall we check we have what we need?')
if check:
    if st.session_state.permission_granted and st.session_state.privilege_granted: # check for permissions again
        st.success('Yup! Looks like we\'ve got all the permissions we need')
    else:
        st.write('Not all permissions granted')
