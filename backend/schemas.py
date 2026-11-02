from pydantic import BaseModel, ConfigDict, field_validator

# Base schema with common attributes
class ItemBase(BaseModel):
    name: str
    description: str | None = None

    @field_validator("name")
    @classmethod
    def name_must_not_be_empty(cls, value: str) -> str:
        if not value.strip():
            raise ValueError('Item cannot be empty,please provide a valid item name')
        return value

# Schema for creating a new item
class ItemCreate(ItemBase):
    pass

# Schema for reading/returning an item (includes id)
class Item(ItemBase):
    id: int
    model_config = ConfigDict(from_attributes=True)
        