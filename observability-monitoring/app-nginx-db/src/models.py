from datetime import datetime
from typing import List, Optional

from sqlmodel import Field, SQLModel


class Book(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    title: str
    created_at: datetime = Field(default_factory=datetime.now)