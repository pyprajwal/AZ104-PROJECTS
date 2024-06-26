This project demonstrates the use of Azure app design to automate user Onboarding processes usually done by System admin/Service desk engineers. It streamlines creating a user account and adds to relevant groups on user titles and department basics.
![image](https://github.com/pyprajwal/AZ104-PROJECTS/assets/61958453/2c59ba1b-2079-402a-8c7f-162da11020b2)

1. Azure AD (Entra ID) setup:

   We need an Azure active directory setup first where we can create user accounts and groups.

2. HTTPS trigger/Receive mail:

   Setup HTTPS trigger or when specific mail like from HR is received we can initiate the flow.
   It should triggered along with necessary details needed for account creation

3. Create a user account:

   Select create user connecter and setup parameters based on the details received from the above HTTPS trigger or mail. This will create a user account in Azure AD

4. Add user to the group:

   Add user to group connector can be setup to add user to group using user id and grouup id. Using conditional user are sepataed
   based on their work title, and department or can be set with any other filed and added to the group.

5. Confirmation email:

   After user account creation and the addition of a group, confirmation is sent to the user or the user's manager with details like email address, username etc.

We can also iterate by adding a resource manager to assign roles or resources like VMs as per user roles and responsibilities.
