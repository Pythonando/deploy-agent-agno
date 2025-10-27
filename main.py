from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.os import AgentOS
from dotenv import load_dotenv

load_dotenv()

agent = Agent(
    model=OpenAIChat(
        id='gpt-4.1-mini'
    ),
    instructions=[
        "Conte piadas sempre limpas e nunca ofensivas.",
        
    ],

)


agent_os = AgentOS(agents=[agent])
app = agent_os.get_app()
