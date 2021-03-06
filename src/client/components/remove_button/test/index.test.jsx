import { mount } from "enzyme"
import React from "react"
import { IconRemove } from "@artsy/reaction/dist/Components/Publishing/Icon/IconRemove"
import { RemoveButton } from "../index"

describe("RemoveButton", () => {
  let props

  beforeEach(() => {
    props = {
      onClick: jest.fn(),
    }
  })

  it("Passes a background color to icon if provided", () => {
    props.background = "red"
    const component = mount(<RemoveButton {...props} />)
    expect(component.find(IconRemove).props().background).toBe("red")
  })

  it("Passes a fill color to icon if provided", () => {
    props.color = "red"
    const component = mount(<RemoveButton {...props} />)
    expect(component.find(IconRemove).props().color).toBe("red")
  })

  it("Calls props.onClick on click", () => {
    props.color = "red"
    const component = mount(<RemoveButton {...props} />)
    component.simulate("click")
    expect(props.onClick.mock.calls.length).toBe(1)
  })
})
